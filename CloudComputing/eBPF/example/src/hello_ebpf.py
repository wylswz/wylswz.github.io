#!/usr/bin/env python3
"""
最小可运行的 eBPF / bcc 示例:统计各进程的 `clone()` 系统调用次数。

运行方式(在容器内):
    python3 hello_ebpf.py
按 Ctrl-C 退出并打印统计结果。
"""

# pyrefly: ignore [missing-import]
from bcc import BPF
import time

SRC_PATH = "hello_ebpf.c"
with open(SRC_PATH, "r") as f:
    bpf_source = f.read()



if __name__ == "__main__":
    b = BPF(text=bpf_source)
    syscall = b.get_syscall_fnname("mmap")
    b.attach_kprobe(event=syscall, fn_name="hello")

    while True:
        copied = dict()
        for key, value in b["counter_table"].items():
            copied[key.comm] = value

        sorted_items = sorted(
            copied.items(), key = lambda item: item[1].value, reverse=True
        )
        i = 0
        print("=========")
        for item in sorted_items:
            if i > 5:
                break
            print(f"{item[0].decode()} - {item[1].value}")
            i += 1
        time.sleep(1)
    
