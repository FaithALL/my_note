## ASIO

[参考1](https://github.com/sprinfall/boost-asio-study)、[参考2](https://think-async.com/Asio/asio-1.18.2/doc/)、[参考3系列文章](https://zhuanlan.zhihu.com/p/39973955)、[Boost.Asio C++编程](https://mmoaay.gitbooks.io/boost-asio-cpp-network-programming-chinese/content/Chapter1.html)

### 开始

* 每个ASIO程序至少有一个`I/O execution context`，如`asio::io_context`、`asio::thread_pool`、`asio::system_context`，用于与操作系统交互。
* 为了完成I/O操作，还需要有`I/O object`，如`asio::ip::tcp::socket`、`asio::steady_timer`。
* 命名空间
  * `asio`：核心类和函数所在，类：`io_context`、`streambuf`。函数：`read`、`read_until`、`write`。
  * `asio::ip`：网络通信相关。类：`addresss`、`endpoint`、`tcp`、`udp`、`icmp`。函数：`connect`。
* [禁用废弃的接口和函数](https://think-async.com/Asio/asio-1.18.2/doc/asio/using.html)：定义宏`ASIO_NO_DEPRECATED`

### asio::io_context

* 有一个`run()`方法，是一个阻塞调用，相当于loop，直到所有异步操作完成后才返回。
  * `run_once()`：至多执行一个异步操作。
* `io_context`是线程安全的，`io_context`实例和处理线程(调用`run()`的线程)的关系可以是`1:1`、`1:n`、`m:n(慎用)`。
* `asio::io_context::strand`：`post(*)`让异步方法顺序调用。

## buffer

* `asio::buffer(*)`、`asio::dynamic_buffer(*)`

### socket

> **可以是tcp、udp、icmp

* ip地址`asio::ip::address`：从字符串ip得到需要的地址：`make_addresss(*)`

* 端点`asio::ip::**::endpoint`：`{address, port}`

* DNS`asio::ip::**::resolver`：`resolve()成员方法`解析出endpoints

* socket

  * `asio::ip::**::socket`、`asio::connect(*)`、`asio::async_connect(*)`
  * `asio::ip::tcp::acceptor`、`acceptor::accept(*)`、`acceptor::async_accept(*)`

* 读写

  | 同步                    | 异步                          |
  | ----------------------- | ----------------------------- |
  | `asio::read(*)`         | `asio::async_read(*)`         |
  | `asio::read_until(*)`   | `asio::async_read_until(*)`   |
  | `asio::write(*)`        | `asio::async_write(*)`        |
  | `socket::read_some(*)`  | `socket::async_read_some(*)`  |
  | `socket::wirte_some(*)` | `socket::async_write_some(*)` |
  | `socket::receive_from(*)` | `socket::async_receive_from(*)` |
  | `socket::send_to(*)`      | `socket::async_send_to(*)`      |

* 使用reactor

  `socket::async_wait(tcp::socket::wait_read, handler)` 

  `socket::async_wait(tcp::socket::wait_write, handler)`


