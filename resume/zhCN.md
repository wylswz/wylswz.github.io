<!-- font: frutiger -->

# 闻云路
**Tel:** +86 15851535018   
**Email:** wylswz@163.com

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

- **Algolib Ltd** *2017/7 - 2018/2*
  
  Web后端开发

  使用 Django, jQuery 和 MySQL 开发欧式期权定价平台
  - 将一些MatLab编写的金融领域的算法移植到Python和C++以用于生产,如ARIMA, ARFIMA, BS公式等
  - 开发web应用，使得用户可以使用基于这些算法的定价引擎，并生成一些数据
  - 提供REST API，为定价引擎生成的数据提供查询接口

- **星环信息科技** *2020/3 - now*

  云计算PaaS开发

  参与Transwarp Data Cloud的开发

  - 开发PaaS平台中的一些服务，包括部署服务，用户控制台（类似OpenStack中的Nova和Horizon）
    - 开发一些API，用来和其他服务同信，共同完成一些复杂任务
    - 进行一些性能分析和优化
  - 贡献一些共享的库，以优化系统的行为，如并发控制，负载均衡和链路追踪


# 项目

## MediumKube *2020/10 - Future*
  MediumKube是用于简化本地部署k8s集群的命令行工具。它支持multipass和libvirt驱动。

  *libvirt后端正在开发中

  - 使用go template实现模板引擎，可以通过用户的配置文件来生产cloud-init数据源
  - 开发命令行界面来提供细粒度的操作，取代原来的脚本一次性部署的方式
  - 增加对libvirt的支持从而对multipass解耦，并提供用于维护虚拟网络的守护进程
  
## Pathfinder 和 Trovu *2020/10 - Future*
  Pathfinder是一个k8s控制器，用于增强原生k8s的行为。它可以实现自动化的服务注册，用户可以做到声明式的服务注册而不用入侵代码。

  Trovu是一个直接和Pathfinder通信的DNS服务，它可以收集注册的服务并且提供xDS标准的解析，以支持Envoy sidecar。通过snapshot机制，它可以降低服务发现对控制面的负载压力

  *此项目仍需大量调研和开发

  - 设计了Pathfinder， Trouv和原生service之间的交互逻辑
  - 使用kubebuilder定义CRD并生成一些辅助代码
  - 实现控制器的逻辑
  - 为Trovu增加用于服务发现的gRPC服务器和对Pathfiunder的监控

## 开源项目贡献

  - **dozer**是一个用于Python web应用资源监控的中间件（wsgi中间件），它帮助我定位了一个严重的内存泄漏。我贡献了“通过单调增减程度排序”的功能，使数量趋近于单调递增的对象被排在更靠前的位置，有利于在规模很大的服务中快速定位内存泄漏。此功能随0.8版本发布


# 技能
- Java和Python的web开发经验
- [个人项目](https://github.com/6BD-org) 中的golang开发经验
- 其他辅助开发的工具/库


# 附录
- **个人博客** https://wylswz.github.io/
- **Github:** https://www.github.com/wylswz