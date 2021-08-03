<!-- font: frutiger -->

# Yunlu **WEN**
**Tel:** +86 15851535018   
**Email:** wylswz@163.com

# Education
- **University of Melbourne**
    *2018/2 - 2019/12*

    School of Computation and Information Systems

    Master of Information Technology
    (Distributed Computing)

- **University of Liverpool**
    *2015/9 - 2017/7*

    Department of Electrical and Electronic Engineering

    Bachelor of Electronic Engineering


- **Xi'an Jiaotong Liverpool University**
    *2013/9 - 2015-7*

    Department of Electrical and Electronic Engineering

    Bachelor if Electrical Engineering

# Career

- **Algolib Ltd** *2017/7 - 2018/2*
  
  Web Developer

  Developping a european pricing engine using Django, jQuery and MySQL.
  - Translate some finantial MatLab libraries into C++ and Python for production, like ARIMA, ARFIMA, some BS Equation, etc.
  - Develop a web application that makes these algorithms available to customers and pruduces some intermediate data. The web app was implemented using Django and jQuery. Generated data is stored in MySQL
  - Provide some REST APIs to query calculation results.

- **Transwarp** *2020/3 - now*

  PaaS Developer

  Transwarp Data Cloud
  
  - Involved in development of couple of services, which are building blocks of a PaaS platform, including deployment service and cloud console (like Nova and Horizon in openstack).
    - Developed some APIs that talk to other services to accomplish complex tasks.
    - Did some perfmance profiling and optimization
  - Contribute to some common libraries.


# Projects

## MediumKube *2020/10 - Future*
  MediumKube is a commandline tool that simplifies local deployment of kubernetes cluster. It's powered by multipass or libvirt. 
  
  *libvirt backend is under development.

  - Implemented templating engine using go template to generate cloud-init user data source from user config
  - Developed a command like tool that provides finer-grained operations rather than single-shot deployment
  - Added support for libvirt command line tools and provided a daemon which maintains network configurations for user
  - Support VM Overlay network, therefore it's possible scale VMs to a cluster

## Pathfinder & Trovu *2020/10 - Future*
  Pathfinder is a customized kubernetes controller that automatically register services to a centralized place (CRD) so that user can do service registration declaratively by adding annotations to their services. 

  Trovu is a DNS service that talks to Pathfinder directly. It collects registered services from Pathfinder and provide DNS to services by implementing xDS protocol(cluster discovery). It alleviates the stress of control plane using snapshots.

  *This project still need huge amount of research and development

  - Designed the interaction between services, Pathfinder and Trovu
  - Defined CRD using kubebuilder and implement the controller
  - Added cluster discovery gRPC server and Pathfinder listener to Trovu

## Open source project contributions

  - **dozer** is a resource monitoring middleware for Python WSGI apps, and it helped me locate a memory leakage and saved my career. I improved it's user experience in very large web application by adding "sort by monolithicity" option, which places monolithically increasing object at the very beginning of the list. This feature is released in 0.8.

<!--

## Article recommendation system based on latent semantic analysis *2017/1 - 2017/4*
  - Data harvesting from wikipedia
  - Apply different approaches of topic modelling (LSA, LDA)
  - Distance based content recpmmendation using KNN search -->


# Skills
- Web app development experience in Java and Python
- [Personal project](https://github.com/6BD-org) experience in golang
- Other tools and libraries included in development


# Appendix
- **Github:** https://www.github.com/wylswz