# Knative Serving 和云成本
笔者有多套 LLMOps 平台，苦于成百上千的插件/沙箱，以及每个月 3000 美元的云服务成本。

Knative Serving 的 Scale to Zero 特性是云成本控制中十分有效的手段。

## Scale to Zero 的难点

当我们说弹性伸缩，往往是 1-N 的伸缩，通常基于一些指标，比如 CPU 使用率、内存使用率、请求量等。

而 Scale to Zero 则是 0-1 的伸缩，这在技术上更加复杂，因为需要处理冷启动、资源预热等问题，因此一定需要网络层的介入。

## HPA 的 scale to zero
k8s 最新版本的 HPA 已经支持 scale to zero，然而，它更适用于一些批处理等任务。当一个 web 服务被 HPA scale to zero，此时如果有请求到达，客户端只能得到一个服务不可用的报错。

## Knative Serving 的架构

### API 抽象

资源层级：`Service → Configuration + Route → Revision → PodAutoscaler → Deployment/Pod`

- **Service (ksvc)**：顶层编排资源，类似 Deployment 之于 ReplicaSet。Spec 内联了 ConfigurationSpec（容器模板）和 RouteSpec（流量分配）。
- **Configuration**：管理 Revision 的"浮动 HEAD"。每次 template 变更产生一个新 Revision，并追踪 `latestCreatedRevisionName` 和 `latestReadyRevisionName`。
- **Revision**：代码+配置的不可变快照。一旦创建不可修改，关键字段包括 PodSpec、ContainerConcurrency、TimeoutSeconds。
- **Route**：流量入口，按百分比将请求分配到多个 Revision。通过 TrafficTarget 声明每个 Revision 的流量占比。
- **PodAutoscaler (PA)**：每个 Revision 对应一个 PA，是 Knative autoscaler 的抽象接口，负责 scale-to-zero 和扩缩容决策。

#### ksvc 控制器行为

创建/更新 ksvc 时，Service Reconciler (`pkg/reconciler/service/service.go`) 执行：

1. **调和 Configuration**：不存在则创建；已存在则对比 Spec/Labels/Annotations，有 diff 则 Update。
2. **等待 Configuration 就绪**：若 Configuration 未 reconcile 完（`Generation != ObservedGeneration`），标记 `ConfigurationNotReconciled` 并等待。就绪后将 Configuration 状态传播到 Service。
3. **调和 Route**：不存在则创建；已存在则对比期望状态，有 diff 则 Update。Route Spec 中未指定 RevisionName 的 TrafficTarget 自动填充 Configuration 名。
4. **传播状态**：将 Route 的 URL、Traffic、Conditions 回写到 Service Status。若 Route 实际流量分配与期望不一致，标记 `RouteNotYetReady`。

整个过程是纯声明式的：Service 只负责编排 Configuration 和 Route，不直接操作 Pod。Revision、PA、Deployment 的管理由各自下游控制器完成。

### 数据面架构
在数据面，serving 通过以下组件实现请求的路由和处理：

- **Activator** (`cmd/activator`)：集群级共享组件。当 Revision 缩到 0 或容量不足时，Ingress 将流量导向 Activator。Activator 通过 Throttler 缓冲请求、触发扩容，待 Pod 就绪后反向代理到目标 Pod 的 Queue Proxy。同时向 Autoscaler 推送并发统计（通过 WebSocket）。
- **Queue Proxy** (`pkg/queue`)：以 sidecar 形式注入每个 Revision Pod。职责：(1) 执行 Breaker 限流，强制 `ContainerConcurrency` 上限；(2) 采集请求级指标（并发数、RPS），区分直连请求和经 Activator 代理的请求；(3) 将统计上报给 Autoscaler 供决策使用。
- **Autoscaler** (`pkg/autoscaler/scaling`)：每个 Revision 对应一个 UniScaler（由 MultiScaler 管理），每 2 秒 tick 一次。基于 stable window 和 panic window 的指标计算 `DesiredPodCount`。当 ExcessBurstCapacity < 0 时，KPA 控制器会将 Activator 插入请求路径（通过 SKS 切换 public endpoint）。
- **Ingress**：可插拔网络层（Istio / Kourier / Contour 等）。Route 控制器生成 Knative Ingress 资源，由对应的 ingress controller 配置实际的 L7 规则，包括域名绑定、TLS 终止和流量百分比拆分。

#### 数据流

```
正常（有 Pod）: Client → Ingress → Queue Proxy → 用户容器
缩零后首请求:  Client → Ingress → Activator → (触发扩容，等待 Pod Ready) → Queue Proxy → 用户容器
```

Activator 在 Pod 充足且 ExcessBurstCapacity > 0 后会被摘出请求路径，流量直连 Pod。

### 可插拔的网络层

#### KIngress：网关适配

Route 控制器创建 KIngress CRD（声明域名规则 + 流量百分比拆分），由 **adapter 控制器** 翻译为具体网关配置：

- **net-istio** → 生成 VirtualService，网关是 Istio 的 Envoy
- **net-kourier** → 直接 xDS 推送，网关是裸 Envoy（无需 Istio）
- **net-contour** → 生成 HTTPProxy，网关是 Contour 的 Envoy

Knative 只写 adapter 控制器，不写网关本身。切换只改 `config-network` 的 `ingress-class`。

#### SKS：Activator 出入开关

每个 Revision 有一个无 selector 的 **public Service**，其 Endpoints 由 SKS 控制器按模式手动写入：

- **Serve 模式**：Endpoints → Pod IP（网关直连 Pod）
- **Proxy 模式**：Endpoints → Activator IP（网关发往 Activator）

另有 private Service（有 selector）始终指向 Pod，供 Autoscaler 抓指标和 Activator 发现后端。

```
Serve:  Gateway → public-svc (Pod:8012) → Queue Proxy → 用户容器
Proxy:  Gateway → public-svc (Activator) → Activator → Pod:8012 → Queue Proxy → 用户容器
```

网关对 Endpoints 切换完全透明，只管按 Service 转发。
