* [进程管理](https://mp.weixin.qq.com/s/YXl6WZVzRKCfxzerJWyfrg)：Linux上的**线程**用`task_struct`描述，也是内核的调度单元。将多个`task_struct`合并为一组(通过该结构内部的组id字段)再来描述一个**进程**。因此，Linux上的线程，也称**轻量级进程**。

  * 线程

    * 用户线程：在用户空间实现线程，内核不知道。
    * 内核线程：在内核实现线程，由内核管理。

    * 轻量级进程(`LWP`)：本质还是进程，和其他进程共享大部分地址空间，有父子关系，和普通进程一样被调度。**`LWP`与普通进程的区别也在于它只有一个最小的执行上下文和调度程序所需的统计信息**。

    > 用户线程和内核线程的对应关系：`N:1`、`1:1`、`M:N`

  * 进程的状态：创建、`就绪`、`运行`、`阻塞`、`挂起`(就绪挂起、阻塞挂起、调用sleep也会挂起)

  * 进程间通信
    * 匿名管道`pipe`：单向，父子进程，内核缓存，先进先出
    * 命名管道`fifo`：单向、任意进程，`fifo`文件，内核缓存，先进先出
    * UNIX域套接字`socketpair`：双向、任意进程，绑定本地文件                         
    * `XSI IPC`(由System V引入，还有`POSIX`版本) 
      * 消息队列：自定义通信格式，内核中的消息链表，通信不及时
      * 信号量：`PV`操作，用于实现进程同步和互斥
      * 共享内存：速度快，两进程虚拟内存映射到同一物理内存
    * 信号`kill`：异步通信机制
    * `socket`：不同主机进程通信

* 虚拟内存：见`CSAPP`

  * 虚拟内存为进程提供一个**大的**、**一致**的和**私有的**地址空间。

  * 虚拟内存的作用

    * 磁盘缓存
    * 更好地内存管理：链接、加载、内存分配、共享(COW)、保护(分配否、root/write/read权限)

  * 虚拟内存被组织为一个存放在**磁盘上**的连续字节的数组。磁盘上数组的内容被缓存在主存中。(虚拟页在磁盘上，物理页在主存上，DRAM采用全相联写回缓存)

  * **页表**：将虚拟页映射到物理页的数据结构。

  * **缺页**：DRAM缓存不命中，缺页会调用内核中缺页异常处理程序，该程序会选择牺牲页。

  * Linux虚拟内存系统`mm_struct`

    <img src="https://img-blog.csdnimg.cn/20190903100346242.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3psNjQ4MTAzMw==,size_16,color_FFFFFF,t_70" style="zoom:50%;" /><img src="https://img-blog.csdnimg.cn/20190903102440501.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3psNjQ4MTAzMw==,size_16,color_FFFFFF,t_70" style="zoom:50%;" />

    * `fork`：创建`mm_struct`，每个页面设为只读，COW创建新页面
    * `execve`：删除已存在私有用户区域、映射私有区域、映射共享区域、设置程序计数器(PC，程序入口)
    * `mmap`：将虚拟页映射到文件所在内存

* 文件

  * **文件共享**：内核用三个相关的数据结构来表示打开的文件

    * 描述符表/进程表：每个进程都有独立的描述符表，用以记录进程打开的文件。含有文件描述符标志、文件表项指针。
    * 文件表：所有进程共享，用以记录操作系统打开的文件。含有引用计数、文件偏移量、v-node表项指针。
    * v-node表：含有`stat`结构大多数信息(文件固有属性)，如`st_mode`、`st_size`

    > `int dup2(int oldfd, int newfd)`就是复制`oldfd`的文件描述符表项到`newfd`

* [提升程序性能手段](https://mp.weixin.qq.com/s/QESU-0wWVP4EsMS629awpw)
  
  * 零拷贝技术：`sendfile/splice/tee`
  * 多路复用技术：`select/poll/epoll`
  * 线程池
  * 无锁编程技术
  * 进程间通信技术：管道、命名管道、socket、信号、消息队列、信号量、共享内存
  * RPC和序列化技术
  * 数据库索引
  * 缓存技术和布隆过滤器
  * 全文搜索技术
  * 负载均衡技术

