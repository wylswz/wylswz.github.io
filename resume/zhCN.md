<!-- font: frutiger -->

# 闻云路
**Tel:** +86 15851535018   
**Email:** wylswz@outlook.com

# 教育
- **墨尔本大学**
    *2018/2 - 2019/12*

    School of Computation and Information Systems

    信息技术硕士 （分布式计算方向）

- **利物浦大学**
    *2015/9 - 2017/7*

    Department of Electrical and Electronic Engineering

    电气工程学士


- **西交利物浦大学**
    *2013/9 - 2015-7*

    Department of Electrical and Electronic Engineering

    电气工程学士

# 职业生涯

- **星环信息科技** *2020/3 - now*

  云计算PaaS开发

  参与Transwarp Data Cloud的开发

  - 维护PaaS平台中的一些服务，包括生命周期管理服务，用户控制台
  - 设计并开发了 TDC 联邦云功能，输出专利两篇（其中一篇是和同事合作）
  - 参与平台瘦身
    - 开发基于 K8s 的服务发现组件（基于 spring-cloud-load-balancer），代替 eureka
    - 服务编排资源配置调优
  - 基于 kubevela 的大数据组件运维
    - 基于 cue 和 go 的互操作性实现工作流的编排
    - 扩展和优化 kubevela 的 op 库（支持sql，提高 patch 效率，优化 log 实现等）
    - 工作流实现从 kubevela 迁移到自研工作流平台
  - 参与平台底层架构的重构（微服务->单体，单集群->多集群）
    - 参与架构设计
    - 设计/开发配置文件分发 operator
    - 千节点集群性能优化

- **杭州轻诊科技（兼职、顾问）** *2025/4 - now*
  
  AI Agent 开发 Advisor

  - 参与生物学领域 Agent 的设计开发
    - 使用 Qdrant 进行知识库搭建。论文分块，过滤
    - Plan-and-Execute Agent 设计
    - 项目采用 langchain + MCP 作为技术栈，解决了生物学领域工具链复杂的挑战。


- **Algolib Ltd** *2017/7 - 2018/2*
  
  Web后端开发

  使用 Django, jQuery 和 MySQL 开发欧式期权定价平台
  - 将一些MatLab编写的金融领域的算法移植到Python和C++以用于生产,如ARIMA, ARFIMA, BS公式等
  - 开发web应用，使得用户可以使用基于这些算法的定价引擎，并生成一些数据
  - 提供REST API，为定价引擎生成的数据提供查询接口


# 项目

## 开源相关
  - **dozer**是一个用于Python web应用资源监控的中间件（wsgi中间件），它帮助我定位了一个严重的内存泄漏。
    - 我贡献了“通过单调增减程度排序”的功能，使数量趋近于单调递增的对象被排在更靠前的位置，有利于在规模很大的服务中快速定位内存泄漏。此功能随0.8版本发布
  - **helm dashboard** 是用来管理集群中 helm chart 和 release 的可视化工具。
    - 我贡献了前端懒加载的功能，借助 react-intersection-observer，让 release 卡片在滚动到可见区域时才加载，优化了性能。
    - 重构 helm dashboard 项目，提供 jsonrpc 接口，供公司项目使用。
  - **tusd** 是一个大文件传输协议的 go 实现
    - 字符串抽成 const 并暴露，使得 Hook 实现可以更容易获取文件路径等信息
  - **ssh4j** 是 java 的 ssh 客户端
    - 我优化了 keepalive 实现。借助优先级队列，由原来每个连接一个 keepalive 线程的模式改成 N 个线程管理 M 个连接的方式（N << M）。 异步的过程单元测试受环境影响比较多，所以还没完成合并。
  - **HAMi** HAMi 是支持异构设备管理的算力虚拟化框架
    - 文档贡献：device-plugin 关键配置项文档贡献。

# 技能
- Java Go 都会一点
- 基于 Kubernetes 的软件开发 （operator）

# 其他
- **Github:** https://www.github.com/wylswz
- **微信公众号**：Janiva on Truffle