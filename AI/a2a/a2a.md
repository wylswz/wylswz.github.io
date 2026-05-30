# A2A 协议

A2A 协议的名字听起来是用于 Agent 之间的相互协作的协议，但它实际上只是一个 C/S 的协议，或者说是一个实现 Agent Server 的脚手架。它的目标是让各种平台的 Agent 变得可互操作。

# A2A 协议是怎么被调用的
- 对于 Agent 来说，它只是一个工具调用，类似（Agent as Tool）。Agent Server 会负责对接 A2A。
- 对于 Agent Server 来说，它需要适配整个协议栈，包括消息的串流，Task 的管理，Artifact 的存储等等。

# 4 种对象
- Task: 一次 Task 就是 agent 完成的一次任务，会包括多轮 Message
- Message：客户端和服务端之间的一次通信。服务端的 Mesage 必须要有 context_id 或者 task_id，如果一次 task 被创建了。
- Part：Message 的组成部分，可以是文本、图片、视频等。
- Artifact：Task 的产物，可以是文件、数据库记录等。