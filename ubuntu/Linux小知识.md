# Linux小知识

* [应用图标（.desktop)文件位置](https://www.cnblogs.com/xiyu714/p/9900525.html)

  - `/usr/share/applications` # 大部分启动图标都在此
  - `~/.local/share/applications` # 一部分本地图标
  - `/var/lib/snapd/desktop/applications` # snap 类软件在此

* 目录结构：遵循[FHS](https://zh.wikipedia.org/wiki/%E6%96%87%E4%BB%B6%E7%B3%BB%E7%BB%9F%E5%B1%82%E6%AC%A1%E7%BB%93%E6%9E%84%E6%A0%87%E5%87%86)

  * `/`
  * `/usr/`
  * `/usr/local`
  * `$HOME/.local`

* su初始密码设定

  ```shell
  sudo passwd
  #设置用户密码
  sudo passwd 用户名
  ```

* 安装软件相关

  * apt命令，apt源修改文件(/etc/apt/sources.list 和 /etc/apt/sources.list.d)

    | 命令             | 功能                     |
    | ---------------- | ------------------------ |
    | apt purge        | 删除软件包及配置文件     |
    | apt search       | 搜索应用程序             |
    | apt show         | 显示细节                 |
    | apt edit-sources | 编辑源列表               |
    | apt remove       | 删除软件包，保留配置文件 |

    -y选项：交互式操作时默认输入Y

  * [apt设置代理](https://zhuanlan.zhihu.com/p/44056084)

    ```shell
    #sudo后貌似不走全局代理
    #为某次使用设置代理
    #设置http
    sudo apt-get -o Acquire::http::proxy="http://<proxy_addr>:<proxy_port>" upgrade
    #设置https
    sudo apt-get -o Acquire::https::proxy="http://<proxy_addr>:<proxy_port>" upgrade
    #也同时设置http和https
    ```

  * [软件包架构](https://linux.cn/article-2935-1.html)

    ```shell
    #查看内核架构(amd64)
    dpkg --print-architecture
    #查看多架构支持(i386)
    dpkg --print-foreign-architectures
    #增加多架构支持(i386)
    sudo dpkg --add-architecture i386
    #移除多架构支持(i386)
    sudo dpkg --remove-architecture i386
    ```

  * [snap设置代理](https://askubuntu.com/questions/764610/how-to-install-snap-packages-behind-web-proxy-on-ubuntu-16-04/1084862#1084862)

    ```shell
    sudo snap set system proxy.http="http://<proxy_addr>:<proxy_port>"
    sudo snap set system proxy.https="http://<proxy_addr>:<proxy_port>"
    #查看代理
    sudo snap get core proxy
    ```

* zip解压缩乱码解决

  ```shell
  unzip -O CP936 xxxx.zip
  #CP936可以视为GBK
  ```

* [定位杀死僵尸进程](https://blog.csdn.net/wzy_1988/article/details/16944789)

  ```shell
  #打印所有进程带有用户自定义选项
  ps -Ao stat,ppid,pid,cmd | grep -e '^[zZ]'
  #重新加载父进程
  kill -HUP ppid
  ```

* ctrl+c、ctrl+z、ctrl+d

  * ctrl + c：强行终止进程，发送SIGINT信号
  * ctrl + z：挂起进程，发送SIGSTOP信号(可用bg使其在后台运行，使用fg转入前台运行)
  * ctrl + d：一个特殊的二进制值，表示EOF，不发送信号(但进程接收后一般是选择终止运行)

* 文件描述符的限制

  ```shell
  #用户级文件描述符限制查看
  ulimit -Hn	#硬限制
  ulimit -Sn	#软限制
  #文件描述符限制修改
  具体在文件/etc/security/limits.conf中修改
  ```

  
