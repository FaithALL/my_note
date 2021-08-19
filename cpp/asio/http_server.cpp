
/**
 * 参考:https://zhuanlan.zhihu.com/p/39973955
 * 用智能指针保证在异步操作执行的时候,对象还有效
 */
#include <asio.hpp>
#include <iostream>

using asio::ip::tcp;

class HttpConnection : public std::enable_shared_from_this<HttpConnection> {
public:
    explicit HttpConnection(asio::io_context &io) : socket_(io) {}

    void async_handle() {
        auto p = shared_from_this();
        asio::async_read_until(socket_, asio::dynamic_buffer(str_),
                               "\r\n\r\n", [this, p](asio::error_code err, std::size_t len) {
                    if (err) {
                        std::cerr << "async_read err: " << err << std::endl;
                        socket_.close();
                        return;
                    }
                    std::cout << str_ << std::flush;
                    std::string str = "HTTP/1.0 200 OK\r\n"
                                      "Content-type: text/html\r\n"
                                      "Content-Length: 22\r\n\r\n"
                                      "<html>I receive</html>";
                    asio::async_write(socket_, asio::buffer(str), [this, p](asio::error_code err, std::size_t len) {
                        if (err) std::cerr << "async_write err: " << err << std::endl;
                        socket_.close();
                    });
                });
    }

    tcp::socket &getSocket() {
        return socket_;
    }

private:
    tcp::socket socket_;
    std::string str_;
};

class HttpServer {
public:
    HttpServer(asio::io_context &io, const tcp::endpoint &endpoint) : io_(io), acceptor_(io, endpoint) {}

    void Start() {
        auto p = std::make_shared<HttpConnection>(io_);
        acceptor_.async_accept(p->getSocket(), [this, p](asio::error_code err) {
            if (err) {
                std::cerr << "async_accept err: " << err << std::endl;
                return;
            }
            p->async_handle();
            // accept一个连接后可以继续accept
            Start();
        });
    }

private:
    asio::io_context &io_;
    tcp::acceptor acceptor_;
};

int main(int argc, char *argv[]) {
    if (argc != 3) {
        std::cerr << "Usage program <ip> <port>" << std::endl;
        return 1;
    }

    try {
        asio::io_context io;
        tcp::endpoint ep(asio::ip::make_address(argv[1]), std::stoi(argv[2]));
        HttpServer server(io, ep);
        server.Start();
        io.run();
    } catch (std::exception &err) {
        std::cerr << err.what() << std::endl;
    }
    return 0;
}
