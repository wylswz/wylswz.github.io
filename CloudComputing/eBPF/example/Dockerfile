FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive
ENV PYTHONUNBUFFERED=1

# 安装 eBPF 工具链与 bcc Python 绑定
RUN apt-get update && apt-get install -y --no-install-recommends \
        ca-certificates \
        curl \
        bpfcc-tools \
        python3-bpfcc \
        python3-pip \
        python3-venv \
        clang \
        llvm \
        libelf-dev \
        zlib1g-dev \
        build-essential \
        linux-tools-generic \
        linux-headers-generic \
        iproute2 \
        iputils-ping \
        procps \
        kmod \
    && rm -rf /var/lib/apt/lists/*

# 升级 pip 并安装辅助 Python 包
# 注意:bcc 模块由系统的 python3-bpfcc 提供,不要用 pip 装
RUN pip3 install --no-cache-dir --upgrade pip \
    && pip3 install --no-cache-dir \
        pyelftools \
        psutil \
        rich

# 入口脚本:为 bcc 准备内核头文件软链(解决 LinuxKit 内核无头文件问题)
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

WORKDIR /workspace

ENTRYPOINT ["/entrypoint.sh"]
# 默认进入交互式 bash
CMD ["/bin/bash"]
