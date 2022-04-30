# systemd

> 参考资料：[Systemd入门教程：命令篇](https://www.ruanyifeng.com/blog/2016/03/systemd-tutorial-commands.html)、[systemd中文手册](http://www.jinbuguo.com/systemd/systemd.html)

## 概念

* Unit：常用service、target、timer

## 目录

* 系统单元目录`/etc/systemd/system`、`/usr/local/lib/systemd/system`、`/usr/lib/systemd/system`
* 用户单元目录`/etc/systemd/user`、`/usr/lib/systemd/user`

## 命令

* systemctl

  ```shell
  # 查看系统所有安装的服务
  systemctl list-unit-files --type=service
  # 查看系统所有运行的服务
  systemctl list-units --type=service
  # 查看服务状态
  systemctl status {service}
  # 启动、停止、重启、重新加载服务
  systemctl start\stop\restart\reload {service}
  # 禁用、启用服务
  systemctl mask\unmask {service}
  # 在增删改units文件后重新读取
  systemctl daemon-reload
  # 查看依赖关系
  systemctl list-dependencies {service}
  # 查看服务units文件
  systemctl cat {service}

* journalctl：查看日志

  ```shell
  # 查看所有日志(默认只保存本次启动日志)
  journalctl
  # 查看指定时间的日志
  journalctl --since 21:00
  # 查看最新20行日志
  journalctl -n 20
  # 查看指定级别日志
  journalctl -p err/warning/notice/info/debug

* systemd-analyze：查看启动耗时

  ```shell
  # 按服务查看启动耗时
  systemd-analyze blame
  # 显示指定服务的启动流
  systemd-analyze critical-chain {service}
  ```

* hostnamectl：查看主机信息

* localectl：查看本地化(语言、键盘等)设置

* timedatectl：查看时区设置
* loginctl：查看当前登录的用户
* resolvectl：查看域名服务器
* networkctl：查看网络连接状态
