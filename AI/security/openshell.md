## 架构

- Gateway：控制面，负责认证、API、持久化、策略下发、凭据解析和 supervisor relay 协调。
- Compute subsystem: 沙盒生命周期管理（创建、删除、状态转换），编排由 compute driver 对接运行时。
- Credentials subsystem: 凭据逻辑解析，实际存储由 credentials driver 对接密钥库。
- Control plane identity: 控制面身份。
- Sandbox identity: 沙盒身份。
- Supervisor：沙盒本地安全边界，准备隔离、获取配置、注入凭据、运行 relay、启动 proxy 和受限 Agent。
- Policy Proxy: 强制出站路径，执行目标、二进制身份、SSRF、TLS/L7、凭据注入和推理拦截。
- Inference router: 沙盒内拦截 `https://inference.local` 转发至模型后端。

## OpenShell 安全模型

### 运行时模型
- Supervisor: root 启动，准备隔离，运行 proxy，获取配置，注入凭据，服务 relay socket，启动子进程
- Agent 子进程：非特权用户，文件系统、进程、网络均受限

### 启动过程
1. Compute Runtime 启动工作负载，注入沙盒身份、回调端点等
2. Supervisor 加载安全策略和运行时设置
3. 准备文件系统访问、进程限制、网络命名空间、凭据解析和推理路由
4. 启动 policy proxy 和本地 SSH server
5. 逆向建立 supervisor session 回到 gateway，用于 exec、log push、config poll 等
6. 以受限用户身份启动 agent

### 隔离层
- 文件系统层：Landlock 限制读写路径
- 进程层：non-root agent 进程，降权
- Seccomp：阻断危险系统调用（含绕过 proxy 的 raw socket 路径）
- 网络命名空间：agent egress 流量强制通过 CONNECT proxy
- Policy Proxy：评估目标、二进制身份、TLS/L7、SSRF 和推理拦截

### 凭据
1. 环境变量注入：凭据存在 Gateway，Supervisor 运行时获取。注入 Agent 和 SSH 子进程环境变量，环境变量值为 placeholder
2. placeholder：请求默认带 placeholder，例如 `Authorization: Bearer {{openshell:resolve:env:KEY_NAME}}`，由 proxy 在允许的目标端点上解析替换