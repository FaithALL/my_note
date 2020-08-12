[TOC]

# Ubuntu20.04

## 问题解决

* 连接wifi

  想办法连接上网后，使用`附加驱动`安装wifi驱动

* 拨号上网

```shell
#最推荐(图形化配置)
终端内nm-connection-editor
+ --> DSL/PPPoE
修改Parent interface为有线网卡
设置Username和Password
保存
重启
```

```shell
#推荐使用
nmcli connection edit type pppoe 
set pppoe.username XXXXX
set pppoe.password XXXXXX
save
yes
quit
#通过右上角连接pppoe
```

```shell
#拨号上网,右上角图标会出现问题
sudo pppoeconf
#将lcp-echo-failure 4 改为 lcp-echo-failure 20 (或者更大，防止断断续续) 
sudo vim /etc/ppp/options
```

* 热点

```shell
终端内nm-connection-editor
+ --> Wi-Fi
设置SSID(热点名称)、Device(设置为有线网卡)
Wi-Fi安全性-->Security(WPA及WPA个人)、密码
常规-->所有用户都可连接这个网络不选
保存
重启
Wi-Fi右上角-->连接到隐藏网络
```

* 换更新源（换阿里云）
* [gnome扩展](https://www.linuxidc.com/Linux/2017-12/149813.htm)

```shell
sudo apt install gnome-tweak-tool
sudo apt install chrome-gnome-shell
#chrome安装GNOME Shell integration插件
#搜索dash to dock ---> turn on
#搜索GSConnect --> turn on
```

* [capslock映射为ctrl](https://www.cnblogs.com/litifeng/p/6667175.html)

  ```shell
  sudo vim /etc/default/keyboard
  增加或修改 XKBOPTIONS="ctrl:nocaps"
  #设置生效
  sudo dpkg-reconfigure keyboard-configuration 
  ```

* [更改锁屏壁纸](https://blog.csdn.net/qq_36285997/article/details/80403620)(暂时弃用)

* [开机动画](https://tianyijian.github.io/2018/04/05/ubuntu-boot-animation/#attention) [动画素材](https://www.gnome-look.org/p/1156215)(暂时弃用)

```shell
tar zvxf Paw-Ubuntu-Floral.tar.gz 
cd Paw-Ubuntu-Floral/
mv paw-ubuntu-floral.plymouth Paw-Ubuntu-Floral.plymouth

# 将Paw-Ubuntu-Floral.plymouth里/lib改为/usr/share

sudo cp -r Paw-Ubuntu-Floral /usr/share/plymouth/themes

sudo update-alternatives --install /usr/share/plymouth/themes/default.plymouth default.plymouth /usr/share/plymouth/themes/Paw-Ubuntu-Floral/Paw-Ubuntu-Floral.plymouth 100

sudo update-alternatives --config default.plymouth 
# 选择Paw-Ubuntu-Floral.plymouth那个
sudo update-initramfs -u
```

## 软件安装

* gcc套件

```shell
sudo apt install build-essential
```

* java

```shell
sudo apt install default-jdk
```

* vim
* make
* git
* vlc(媒体播放)
* [搜狗输入法](https://pinyin.sogou.com/linux/?r=pinyin)(弃用)

```shell
#先安装Fcitx 和 Fcitx配置，用自带的Ubuntu软件市场安装

#fctix CPU占用100%解决 => fctix配置 -> 附加组件 -> 高级 -> 搜狗云拼音关闭
```

* [坚果云](https://www.jianguoyun.com/s/downloads)(停用)
* [typora](https://www.typora.io/#linux)

```shell
# or run:# sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys BA300B7755AFCFAE
wget -qO - https://typora.io/linux/public-key.asc | sudo apt-key add -

# add Typora's repository
sudo add-apt-repository 'deb https://typora.io/linux ./'
sudo apt-get update

# install typora
sudo apt-get install typora
```

* [WPS Office 2019 For Linux](https://linux.wps.cn/)(安装字体)(停用)

* [google chrome](https://www.google.com/chrome/)
  
  * [谷歌访问助手](https://github.com/haotian-wang/google-access-helper)
  
* [IDEA](https://www.jetbrains.com/idea/download/#section=linux)

* [CLion](https://www.jetbrains.com/clion/download/#section=linux)

* [QT](http://download.qt.io/archive/qt/)

  ```shell
  sudo apt install qt5-default qtcreator
  ```
  
* 文档查看工具

  ```shell
  sudo apt install devhelp
  ```

  导入cppreference

  ```shell
  sudo apt install cppreference-doc-en-html 
  ```

* tmux

  ```shell
  sudo apt install tmux
  ```

* 安装字体

  ```shell
  在/usr/share/fonts/下创建子目录myfont
  将字体复制的myfont下
  mkfontscale
  mkfontdir
  fc-cache -fv
  ```

* flameshot

  ```shell
  sudo apt install flameshot
  #添加快捷键(命令为flameshot gui)
  ```

* vmware

  ```shell
  sudo chmod +x VMware-Workstation-Full-15.5.2-15785246.x86_64.bundle
  sudo ./VMware-Workstation-Full-15.5.2-15785246.x86_64.bundle
  #卸载命令
  sudo vmware-installer -u vmware-workstation
  #禁用开机自启服务
sudo update-rc.d vmware disable
  sudo update-rc.d vmware-USBArbitrator disable
  sudo update-rc.d vmware-workstation-server disable
  #手动开启vmware服务
  sudo /etc/init.d/vmware start 
  sudo /etc/init.d/vmware-workstation-server start
  sudo /etc/init.d/vmware-USBArbitrator start
  ```
  
* virtualbox

  ```shell
  sudo apt install virtualbox virtualbox-ext-pack
  ```
  
* wireshark

  ```shell
  sudo apt install wireshark #中途选Yes或者
  #sudo dpkg-reconfigure wireshark-common 选Yes
  #让非root用户可捕获
  sudo usermod -a -G wireshark 用户名
  ```

* postgresql

  ```shell
  sudo apt install postgresql
  #设置postgres用户密码
sudo -u postgres psql
  psql
  \password
  输入新密码
  #禁止postgresql开机自启
  sudo update-rc.d postgresql disable
  ```
  
* doxygen & graphviz

  ```shell
  sudo apt install doxygen doxygen-gui graphviz
  ```

  
