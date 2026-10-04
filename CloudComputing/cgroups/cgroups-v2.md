# Cgroups v2

1. Cgroups V2 区别于 V1，它是一棵全局的树结构，每个节点都是一个 cgroup。
2. 叶子节点关联进程，非叶子节点只用于组织和控制。
3. cgroups 分为 core 和 controller
    - core: 负责整体树结构的组织
    - controller: 负责向子节点传递资源限制
4. 向下约束：cgroups 每一层都会继承父节点的资源约束，并可以进一步定义更严格的约束。
5. 向上约束：父节点的 controller 一定是子节点 controller 的超集。
6. 接口文件：cgroup 是通过虚拟文件系统进行交互，和 cgroup 交互用的文件是接口文件。类似于 core 和 controller，接口文件也分为 core 和 controller。例如 core 里的接口文件有：
  - cgroup.procs: 用于将进程添加到 cgroup 中
  - cgroup.subtree_control: 当前 cgroup 和其所有子 cgroup 能用的 controller
  - cgroup.controllers: 用于查看当前 cgroup 的 controller
  
  controller 的接口文件：
  - cpu.max: 用于设置 CPU 使用的最大值
  - cpu.weight: 用于设置 CPU 权重，用于多个子 cgroup 之间的 CPU 使用分配

7. 委派机制：可以通过 chmod chown 等方式，对非特权用户授权对 cgroup 的控制权。其获得对 cgroup 的读写。