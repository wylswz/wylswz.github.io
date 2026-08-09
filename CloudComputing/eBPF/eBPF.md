# eBPF

eBPF (extended Berkeley Packet Filter) 是一种在 Linux 内核中运行沙盒程序的技术，它允许用户空间程序安全地在内核中执行代码，而无需修改内核源码或加载内核模块。

## 基本使用
以系统调用统计为例：

1. 编写 eBPF 程序（类 C 代码）
2. 加载程序，并附着到指定的内核事件（如系统调用、函数入口等）
  - 编译成字节码
  - 验证字节码（安全检查）
  - 加载时 JIT 编译成机器码
3. 在用户空间通过 eBPF map 访问收集的数据

```py
if __name__ == "__main__":
    b = BPF(text=bpf_source)                        # 加载 eBPF 程序
    syscall = b.get_syscall_fnname("mmap")          # 获取 mmap 系统调用的函数名
    b.attach_kprobe(event=syscall, fn_name="trace") # 在 mmap 系统调用处附加 trace 函数

    while True:
        for key, value in b["counter_table"].items(): # 用户空间访问 eBPF map
            print(f"{key.sym} - {value.value}")
```

```C
struct key_t {
  u64 pid;
  char comm[16];
}; // -> 定义 map 中 key 的类型

BPF_HASH(counter_table, struct key_t, u64); // -> 定义一个 hash map，key 为 struct key_t，value 为 u64

int hello(void *ctx) {
  u64 *cnt = 0;

  struct key_t key = {};
  key.pid = bpf_get_current_pid_tgid();              // -> 获取当前进程 ID
  bpf_get_current_comm(&key.comm, sizeof(key.comm)); // -> 获取当前进程名

  cnt = counter_table.lookup(&key);                  
  if (cnt) {
    (*cnt)++;
    counter_table.update(&key, cnt);
  } else {
    u64 one = 1;
    counter_table.update(&key, &one);
  } // -> 统计被附着函数被调用的次数
  return 0;
}
```

通过示例的程序，我们可以获得调用 `mmap` 最多的进程
```
=====mmap 名人堂====
shellctl - 2322
pip3 - 191
nginx - 101
check - 101
pg_isready - 40
find - 32
mkdir - 28
awk - 27
redis-cli - 25
sh - 22
modprobe - 22
```

## Map 类型
map 可供 eBPF 程序和用户空间程序共同访问。使用场景包括但不限于
1. 用户空间写入配置给 eBPF 用
2. eBPF 存状态，在不同调用之间读写
3. eBPF 向用户空间传递结果

### HASH
```C
BPF_HASH(table, key_type, value_type);
table.lookup(&key);
table.update(&key, &value);
table.delete(&key);
```
### Perf 缓冲区 / 环形缓冲区

||Perf 缓冲区|环形缓冲区|
|---|---|---|
|内存|每个 CPU 一个|所有 CPU 共享|
|排序|CPU 之间可能乱序|有序|
|数据拷贝|两次：先到本地变量，再到缓冲区|一次：预留缓冲区空间后直接使用|
|性能|事件数多的时候吞吐量（每秒百万次）|绝大多数情况下，性能更好|

环形缓冲区不管在内存拷贝，API 风格还是事件顺序，都是相对更友好的。

