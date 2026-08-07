#!/usr/bin/env bash
#
# 在 Ubuntu 容器里跑 eBPF Python 代码的便捷脚本。
#
# 用法:
#   ./run.sh                 # 构建镜像并进入交互式容器
#   ./run.sh hello_ebpf.py   # 构建镜像并在容器内直接运行指定脚本
#
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
COMPOSE_FILE="$SCRIPT_DIR/docker-compose.yaml"
TARGET="${1:-}"

# 1. 构建镜像(已存在则跳过)
echo "[*] 构建 ebpf-python 镜像 ..."
docker compose -f "$COMPOSE_FILE" build

if [[ -z "$TARGET" ]]; then
    # 2a. 进入交互式 shell,可在里面手动跑 python
    echo "[*] 进入容器,工作目录已挂载到 /workspace"
    echo "    示例:python3 hello_ebpf.py"
    echo ""
    docker compose -f "$COMPOSE_FILE" run --rm ebpf
else
    # 2b. 直接在容器内运行指定脚本
    echo "[*] 在容器内运行:python3 $TARGET"
    docker compose -f "$COMPOSE_FILE" run --rm ebpf python3 "$TARGET"
fi
