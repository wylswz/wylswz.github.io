## 架构

- Gateway：控制面，负责配置策略，凭据等。
- Compute subsystem: 计算面，负责工作负载生命周期管理。
- Credentials subsystem: 凭据存储和解析。
- Control plane identity: 控制面身份。
- Sandbox identity: 沙盒身份。
- Supervisor：负责沙盒内隔离性配置。
- Policy Proxy: 出站代理，应用出站策略，凭据注入等。
- Inference router: 推理路由，控制模型调用。

## OpenShell 安全模型

### 运行时模型
- Supervisor: 作为根进程启动，准备隔离性环境，代理，获取配置，注入凭据，启动子进程
- Agent 子进程：非特权用户，fs，网络隔离

### 启动过程
1. Compute Runtime 启动工作负载
2. Supervisor 加载安全策略，准备凭据等
3. 启动 policy 代理，本地 ssh
4. 和 gateway 反向建立连接，用于 exec，log push 等 （Sandbox 不用暴露入站端点）
5. 启动 agent

### 隔离层
- fs 层：landlock 限制路径访问
- 进程层：non-root agent 进程
- seccomp：系统调用
- 网络命名空间：agent egress 流量强制通过 proxy
- Polocy Proxy：出站流量经过 policy 引擎验证

### 凭据
1. 环境变量注入：凭据存在 Gateway，supervisor 运行时获取。通过环境变量注入 agent。环境变量不是明文，而是 placeholder
2. placeholder：请求默认带 placeholder， 例如 Authorization: Bearer {{openshell:resolve:env:KEY_NAME}}，由 proxy 解析替换。