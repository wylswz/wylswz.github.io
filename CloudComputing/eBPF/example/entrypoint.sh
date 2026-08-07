#!/usr/bin/env bash
#
# 容器启动时为 bcc 准备内核头文件软链。
#
# bcc 编译 BPF 程序时会去 /lib/modules/$(uname -r)/build 找内核头文件。
# Docker Desktop (macOS) 的 LinuxKit 内核(如 6.12.76-linuxkit)没有对应头文件,
# 这里把容器内自带的 Ubuntu 头文件软链过去,让 bcc 能完成编译。
#
# 注意:头文件版本(如 5.15)与运行内核(如 6.12)不一致,
# 只用到 UAPI 类型 / bcc 自带头文件的简单程序(tracepoint、kprobe、
# bpf_trace_printk 等)通常可正常编译运行;若程序引用了版本相关的
# 内核内部结构,仍可能失败。
set -e

KVER="$(uname -r)"
MOD_DIR="/lib/modules/${KVER}"
HEADERS_DIR="$(ls -d /usr/src/linux-headers-*-generic 2>/dev/null | head -n1 || true)"

if [[ -n "${HEADERS_DIR}" && ! -e "${MOD_DIR}/build" ]]; then
    mkdir -p "${MOD_DIR}"
    ln -sf "${HEADERS_DIR}" "${MOD_DIR}/build"
    echo "[entrypoint] 已链接 ${MOD_DIR}/build -> ${HEADERS_DIR}"
fi

# 挂载 debugfs / tracefs,kprobe_events 等文件需要它们
# (容器是 privileged,有权限挂载)
mkdir -p /sys/kernel/debug
if ! mountpoint -q /sys/kernel/debug 2>/dev/null; then
    mount -t debugfs none /sys/kernel/debug 2>/dev/null && \
        echo "[entrypoint] 已挂载 debugfs -> /sys/kernel/debug" || \
        echo "[entrypoint] 警告:debugfs 挂载失败"
fi
mkdir -p /sys/kernel/tracing
if ! mountpoint -q /sys/kernel/tracing 2>/dev/null; then
    mount -t tracefs none /sys/kernel/tracing 2>/dev/null && \
        echo "[entrypoint] 已挂载 tracefs -> /sys/kernel/tracing" || \
        echo "[entrypoint] 警告:tracefs 挂载失败"
fi
# 部分内核通过 /sys/kernel/debug/tracing 暴露 tracing 接口
if [[ ! -e /sys/kernel/debug/tracing ]]; then
    ln -sf /sys/kernel/tracing /sys/kernel/debug/tracing 2>/dev/null || true
fi

exec "$@"
