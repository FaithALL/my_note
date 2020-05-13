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

  
