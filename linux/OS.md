* 虚拟内存：见CSAPP

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

* Linux上的**线程**用`task_struct`描述，也是内核的调度单元。将多个`task_struct`合并为一组(通过该结构内部的组id字段)再来描述一个**进程**。因此，Linux上的线程，也称**轻量级进程**。

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

