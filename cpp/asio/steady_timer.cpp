
#include <asio.hpp>
#include <iostream>
#include <chrono>
#include <functional>

using namespace std::chrono_literals;

int main() {
    asio::io_context io;
    asio::steady_timer timer(io, 2s);

    // 每2s打印"tick"
    std::function<void(asio::error_code)> func = [&timer, &func](asio::error_code err) {
        if (err) {
            std::cerr << err << std::endl;
            return;
        }
        std::cout << "tick" << std::endl;
        timer.expires_after(2s);
        timer.async_wait(func);
    };

    timer.async_wait(func);

    io.run();
    return 0;
}
