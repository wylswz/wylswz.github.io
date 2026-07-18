# Landlock
Landlock 是 linux 5.13 引入的安全机制，它的核心思想机制总结为一句话：自缚手脚。它最大的特点是无需特权，这在企业合规场景下非常有用，因为企业服务通常需要容器在非 root 用户下运行，而 Landlock 可以在不提升权限的情况下限制容器的文件系统访问。

随着 LLM Agent 技术的普及，Landlock 在 Agent 安全防护方面也发挥着越来越重要的作用。

## 主要特性

### 通用特性
- **不可逆**: 一旦 enforce，只能追加更多限制，不能移除已有限制。
- **继承性**: 子线程/进程通过 `clone(2)` 自动继承父线程的 Landlock 限制，类似 seccomp。
- **分层叠加**: 多次 enforce 的 ruleset 会叠加为多层策略，所有层都允许才能访问。
- **ptrace 限制**: 沙盒化的进程只能 ptrace 同一个 sandbox 内的进程，避免跨进程绕过 fs 权限泄漏数据。
- **fd 权限绑定**: `truncate`/`ioctl` 权限在 `open(2)` 时确定并绑定到文件描述符，后续操作不再检查。同一文件的不同 fd 可能具有不同的 Landlock 权限。

### V1 (Linux 5.13)
基础文件系统访问控制，支持以下权限粒度：
- **文件**: 执行 (`EXECUTE`)、读 (`READ_FILE`)、写 (`WRITE_FILE`)
- **目录**: 读取/列出 (`READ_DIR`)
- **目录内容操作**: 删除目录 (`REMOVE_DIR`)、删除文件 (`REMOVE_FILE`)、创建字符设备 (`MAKE_CHAR`)、创建目录 (`MAKE_DIR`)、创建普通文件 (`MAKE_REG`)、创建 UNIX socket (`MAKE_SOCK`)、创建命名管道 (`MAKE_FIFO`)、创建块设备 (`MAKE_BLOCK`)、创建符号链接 (`MAKE_SYM`)
- **限制**: 不支持跨目录 link/rename（reparent），一律拒绝。即使对源目录和目标目录都有完全权限，只要父目录不同就返回 `EXDEV`，与权限范围无关

### V2 (Linux 5.19)
新增 `LANDLOCK_ACCESS_FS_REFER`：允许控制跨目录的 link/rename（reparenting）。V1 中此操作一律被拒绝，V2 起可显式授权。这是唯一一个默认拒绝的权限，即使未在 ruleset 中声明为 handled 也会拒绝。

### V3 (Linux 6.2)
新增 `LANDLOCK_ACCESS_FS_TRUNCATE`：控制文件截断操作（`truncate(2)`、`ftruncate(2)`、`creat(2)`、`open(2)` with `O_TRUNC`）。V1/V2 中截断始终允许。

### V4 (Linux 6.7)
新增 TCP 网络访问控制：
- `LANDLOCK_ACCESS_NET_BIND_TCP`：限制 bind TCP 本地端口
- `LANDLOCK_ACCESS_NET_CONNECT_TCP`：限制 connect TCP 远程端口

### V5 (Linux 6.10)
新增 `LANDLOCK_ACCESS_FS_IOCTL_DEV`：限制对字符/块设备调用 `ioctl(2)`。部分通用 IOCTL 命令（如 `FIOCLEX`、`FIONBIO`、`FIFREEZE` 等）不受此限制，始终允许。

### V6 (Linux 6.12)
新增 IPC 隔离（scope flags），用于隔离沙盒进程与域外资源的交互：
- `LANDLOCK_SCOPE_ABSTRACT_UNIX_SOCKET`：禁止连接域外进程创建的抽象 UNIX socket
- `LANDLOCK_SCOPE_SIGNAL`：禁止向域外进程发送信号

### V7 (Linux 6.15)
新增日志控制，通过 `landlock_restrict_self()` 的标志控制 Landlock 审计日志：
- `LANDLOCK_RESTRICT_SELF_LOG_SAME_EXEC_OFF`：关闭同 exec 域的日志
- `LANDLOCK_RESTRICT_SELF_LOG_NEW_EXEC_ON`：开启新 exec 域的日志
- `LANDLOCK_RESTRICT_SELF_LOG_SUBDOMAINS_OFF`：关闭子域日志

### V8 (Linux 7.0)
新增 `LANDLOCK_RESTRICT_SELF_TSYNC`：允许 `landlock_restrict_self()` 对调用进程的所有线程生效（线程级同步），而非仅当前线程。

### V9 (Linux 7.1)
新增 `LANDLOCK_ACCESS_FS_RESOLVE_UNIX`：限制连接路径名 UNIX domain socket（`connect(2)` 及 `sendmsg(2)` 指定接收地址）。仅限制连接域外创建的 UNIX server socket，域内新建的仍可访问。

### V10 (Linux 7.2)
新增两项能力：
- **UDP 网络控制**：
  - `LANDLOCK_ACCESS_NET_BIND_UDP`：限制 bind UDP 本地端口（含自动 autobind 临时端口）
  - `LANDLOCK_ACCESS_NET_CONNECT_SEND_UDP`：限制设置 UDP 远程端口及向指定远程端口发送数据报
- **静默规则标志** `LANDLOCK_ADD_RULE_QUIET`：可按对象选择性抑制拒绝访问的审计日志，配合 `quiet_access_fs`、`quiet_access_net`、`quiet_scoped` 字段使用

