# Linux小知识

* [应用图标（.desktop)文件位置](https://www.cnblogs.com/xiyu714/p/9900525.html)

  - `/usr/share/applications` # 大部分启动图标都在此
  - `~/.local/share/applications` # 一部分本地图标
  - `/var/lib/snapd/desktop/applications` # snap 类软件在此

* 软件路径

  * /usr/lib
  * /usr/bin

* su初始密码设定

  ```shell
  sudo passwd
  #设置用户密码
  sudo passwd 用户名
  ```

* apt命令

  | 命令             | 功能                     |
  | ---------------- | ------------------------ |
  | apt purge        | 删除软件包及配置文件     |
  | apt search       | 搜索应用程序             |
  | apt show         | 显示细节                 |
  | apt edit-sources | 编辑源列表               |
  | apt remove       | 删除软件包，保留配置文件 |

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

* [设置snap代理](https://askubuntu.com/questions/764610/how-to-install-snap-packages-behind-web-proxy-on-ubuntu-16-04/1084862#1084862)

  ```shell
  sudo snap set system proxy.http="http://<proxy_addr>:<proxy_port>"
  sudo snap set system proxy.https="http://<proxy_addr>:<proxy_port>"
  #查看代理
sudo snap get core proxy
  ```
  
  
