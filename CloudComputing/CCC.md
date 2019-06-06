# Revision 

## Parallelization (L3)

### Computation Scaling Up
- **Single machine multiple cores**
- **Loosely coupled cluster**
  - Web services, Condor, Seto@home, Boinc
- **Tightly coupled cluster of machines**
  - HPC/HTC (SPARTAN, NCI, ...)
- **Widely distributed clusters of machines**
- **Hybrid combinations of above**

### Amdahl's Law

$T(1) = \sigma + \pi$

$T(N) = \sigma + \frac{\pi}{N}$

$S = \frac{T(1)}{T(N)} \approx \frac{1}{\alpha}$

This over simplifies the problem, because the overhead replicates in parallelization


### Gustafson-Barsis's Law
$T(1) = \sigma + N\pi$
$T(N) = \sigma + \pi$

where $\pi$ is fixed parallel time per process and $\alpha$ is fraction of running time sequential program spends on parallel part
$\frac{\pi}{\sigma} = \frac{1-\alpha}{\alpha}$

$S(N) = \alpha + N(1-\alpha) = N - \alpha(N-1)$

### Computer Architectures

- **Single Instruction, Single Data stream(SISD)**
  - Sequential computer
  - Single CPU fetch instruction, CPU generate appropriate control signals to direct single processing element to operate on single data stream
- **Single Instruction, Multiple Data stream (SIMD)**
  - multiple processing elements that perform the same operation on multiple data simultaneously
  - Focus on data level parallelism.
  - Many moder computers use SIMD instructions, e.g., to improve performance of multimedia use such as for image processing
- **Multiple Instruction, Single Data stream (MISD)**
  - Parallel computing arch. Many functional units perform different operations on same dataset
  - Fault tolerant computer architecture, running multiple error checking processes on same data stream
- **Multiple Instruction, Multiple Data stream**
  - Number of processors that function asynchronously and independently
  - At any time, different processors may be executing different instructions on different pieces of data
  - Machines can be shared memory or distributed memory categories
  - Most systems these days operate on MIMD


### Types of parallelisms
**Implicit parallelism** means
parallel languages and parallelizing compilers that take care of identifying parallelism, the scheduling of calculations and placement of data. This is quite hard to do though.

**Explicit parallelism** requires the programmer to take effort of parallelization, like mapping tasks to processors and inter-process communications. This approach assumes user is the best judge of how parallism can be exploited for a particular application.
 
### Hardware parallelism level
In hardware threading CPU, extra control units are added to allow more instructions to be processed per cycle. They usually share arithmetic units, so heavy use of one type of computation can tie up the available units of the CPU preventing other threads from using them.

Multi-core CPU can perform computational tasks in parallel in principle. The Control units have indenpendant arithmatic units but share cache.

Symmetric Multiprocessing means two or more identical processors connected to a single shared main memory, with full access to all I/O devices, controlled by a single OS that treats all processors equally. It's more complex to program since need to program both CPUs and inter-processor communications.

Non-Uniform Memory Access provides speed up by allowing a processor to access its local memory faster than non-local memory. As long as data are localized, performance is improved.

### Software Parallelism Approaches

Most languages support parallelization features like Threads, Pools, Lock, Semaphores. There are some key issues that need to be tackled. Deadlock (Process constantly wait for each other), Livelock (Processes involved in livelock constantly change with regard to one another, but none are progressing)

Message passing interface (MPI) is widely adoped approach for message passing in parallel system. Key MPI functions include MPI_Init, MPI_Finalize, MPI_COMM_SIZE, MPI_COMM_RANK, MPI_SEND, MPI_RECV, ... It supports both point to point and broadcast communications.


(HT)Condor It is a specialized workload management system for compute-intensive jobs. It offers job queueing mechanisms, scheduling policies, priority schemes, resource monitoring/management. Users submit jobs to Condor and it chooses when and where to run the job, monitors their progress and informs the user upon completion. There no need for shared file system across machines, data can be staged to machines as needed. 

### Facts about Distributed Systems
- Network is unreliable
- Latency
- Limited Bandwidth
- Network is insecure
- Topology changes
- Transport cost
- Heterogeneous networks
- Time is not synchronized
  

### How to design a parallel system?

- **Partitioning**: Decomposition of computational activities and data into smaller tasks.
- **Communication**: **Flow** of information and **coordination** among tasks that are created in the partitioning stage.
- **Agglomeration**: 
  - Tasks and communication structure created in the above stages are evaluated for performance and implement cost
  - Tasks may be grouped into larger tasks to improve comm
  - Individual comm can be bundled
- **Mapping**: Assigning tasks to processors such that job completion time is minimized and resource utilization is maximized.

In master-slave model, master decomposes the problem into small tasks and distributes to workers and gather partial results to produce final result.


### Shared memory parallelism (MP)
Multi-threading is one type of shared memory parallelism. A master forks a number of sub threads and diveide tasks between them. One implementation is OpenMP, which is limited to single instance.

### Distributed memory parallelism (MPI)
Programs are parallelized by sending messages between processes. Some functions in MPI are:
- **Bcast**: Broadcast same piece of data to all processes
- **Scatter**: Send a part of data from one process to all the processes (each process get different pieces of data)
- **Gather**: Gather data from all processes
- **Reduce**: Perform a reduce operation, return the result to root.

### Parallism Patterns
- **Master-Slave**: Master decomposes problem to smaller tasks, distribute them to workers and gather the results. Many ways to do it: Threading, Web service workflow ...
- **Single Process Multiple Data**: Each process executes same piece of code but on different parts of data. Data is splitted among available processors
- **Data Pipelining**: Includ multiple stages of execution, that typically operate on large number of dataset
- **Divide & Conquer**: Divide problem into sub-problems which can be independently solved. Master-worker is like divide & conquer with master doing split and join operation.
- **Look ahead execution**: C depends on P for some output value V,  then C predict V. If that's correct, there's a performance gain, otherwise restart the task with correct V.






## Cloud (L5)

### Definition
Cloud computing is a model for enabling ubiqutous convenient, on demand network access to a pool of configurable computing resources that can be repidly provisioned and released with minimal management effort and provider interaction. Cloud computing has following characteristics:
- On-demand self-service
- Broad network access
- Resource pooling
- Rapid elasticity
- Measured service

### How to attach a volume
- Create mounting point in fs
- Format the volume (for nectar cloud, it's in /dev/vdb)
- Mount the volume to the mounting point

### Public cloud
Pros:
- Cost efficient
- Focus on core business
- Right sizing
- Democratisation of computing

Cons
- Security
- Loss of control
- Lock in
- Depends on cloud provider


### Private cloud
Pros:
- More control
- Secure
- Consolidation of resource
- Trust

Cons:
- Management & maintenance overhead
- Relevant to core business>?
- Hardware obsolescence
- Over/under utilization

## Web Service (L6)

### SOAP vs ReST
| SOAP | ReST |
|------|------|
|Built upon RPC| About resources and the way they can be manipulated remotely|
|Stack of protocols that covers every aspect of using a remote service|A style of using HTTP|

### WSDL (Web service description language)
- XML based, machine readable
- Key components
  - **Definition**: what it does?
  - **Target Namespace**: context of naming
  - **Data Types**: Data structure of input/output
  - **Messages**: Messages & structures exchanged between client/server
  - **Port type**: Encapsulate input/output messages into one logical operation(abstract)
  - **Bindings**: bind operations to port types (Concrete operatiosn)
  - **Service**: Name of service

### SOA (Service-Oriented Architecture) Design Principle
- **Standardized Service Contract**: Services adhere to a communication aggrement
- **Loose Coupling**: Minimized dependency; Only maintain an awareness of each other
- **Abstraction**: The information published is limited to what is required to effectively utilize the service.
- **Reusability**: Logic is divided into services for reuse
- **Autonomy**: Service cannot contain logics that depends on anything external.
- **Statelessness**: Separate services with their state data whenever possible. Data management delegated to separated service.
- **Discoverablility**: Communicative meta-data by which they can be discovered/interpreted
- **Composability**: Services are effective compisition participants, regardless size/complexity
- **Granularity**: Services are at right ganular level
- **Normalization**: Minimized redundancy (by decompising/consolidation)
- **Service Optimization**: Prefer high quality specific purpose services over low quality general purpose ones
- **Service Relevance**: At a ganular level such that it's meaningful to users
- **Encapsulation**: Hidden inner work

### ReST design best practice
- Short URI
- URI discovered by following links, instead of constructed by clients
- Use nouns instead of verbs
- Use links in response
- Minimize query string
- Use HTTP status code

### ReST principles
- Addressability
- Uniform interface
- Resources and representations instead of RPC
- HATEOAS

### Uniform interface
- All important resources are identified by one resource identifier mechanism
- Resource has different representations (application/json, text/html, ...)
- Requests contain headers describing how the content should be processed

### HATEOAS (Hyper Media As the Engine of App)
- Link to identify resources
- Navigate through resources
- Navigate instead of calling

### ReST 2.0
- Everything as a service
- Vast number of entities and services
- Link services to create workflows
- Extend API to web Apps
- API Hub to facilitate the sharing and usage of service among developers, users, ...

### Safe/Idempotent methods
A method is safe if does not change anything. (N calls == 0 call). A method is idempotent if (N calls = 0 call)

|Method|Safety|
|------|------|
|GET, OPTION, HEAD| Safe|
|PUT, DELETE|Idempotent|
|POST|Neither|


### Virtualization vs Containerization
Virtualization has advantages like containment and horizontal scalability, but requires more resources. Guest OS and binaries might be duplicated, wasting resources.

Containerization allows virtual instances to share a single host OS, binaries, drivers and libraries to reduce waste.

|Paraleter|VM|Container|
|---------|--|---------|
|Guest OS|Has their own kernel|Share same kernel| 
|Comm|Eth|Pipes, sockets| 
|Security|Depends on Hypervisor|Requires close scrutiny| 
|Performance|Small overhead when translating instructions|Near native| 
|Isolation|FS and lib not shared|Shared lib, fs can be shared| 
|Startup|Slow|Fast|
|Storage|Large|Small|

### Container Orchestration
Manage containers at scale

Features:
- Networking
- Scaling
- Service discovery and load balancing
- Health check and self-healing
- Security
- Rolling updates

Goals
- Simplify container management process
- Help manage availability and scaling

### Docker
It uses resource isolation features of Linux Kernel to allow independent containers to run within a single Linux instance. Can also be installed on Macos and windows, integrated with Hypervisor in maxOS and Hyper-V in windows.

Data can be persisted when container is deleted using docker volumes or bind mounts. Docker volumes are managed by docker, in `/var/lib/docker/volumes`, while bindmount is managed by user.

## Big Data (L7)
4 Vs
- **Volume**
- **Velocity**
- **Veracity**
- **Variety**

### MongoDB vs CouchDB
MongoDB clusters are more complex, more consistent and less available. The sharding is on the replicaset level. Routers must be embedded in application servers. Only master node accept queries (depending on configurations) 

CouchDB cluster is simpler, more available. Accepts HTTP requests. All the nodes accept requests. If data unavailable, it fetch from other node and return to user.

### CAP theorem
- **Consistency**: Every client receives the same answer from all nodes in the cluster.
- **Availability**: Every client receives an answer from any node in cluster
- **Partition-tolerance**: The cluster keeps on operating when one or more nodes cannot communicate with rest of the cluster.