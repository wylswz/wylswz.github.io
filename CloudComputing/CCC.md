# Revision 

## L3

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

