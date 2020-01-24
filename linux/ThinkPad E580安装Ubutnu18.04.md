[TOC]

# ThinkPad E580安装Ubutnu18.04

## 问题解决

* [连接wifi](https://github.com/tomaspinho/rtl8821ce)(bios要禁用安全启动)

* 拨号上网，[方法二](https://jingyan.baidu.com/article/59a015e37dbea2f79588655c.html)

```shell
#拨号上网
sudo pppoeconf
#将lcp-echo-failure 4 改为 lcp-echo-failure 20 (或者更大，防止断断续续) 
sudo vim /etc/ppp/options
```

* 换更新源（换阿里云）
* dock美化

```shell
sudo apt install gnome-tweak-tool
#安装dash to dock 用Ubuntu自带的应用商店
```

* [capslock映射为ctrl](https://www.cnblogs.com/litifeng/p/6667175.html)

```shell
优化 -> 键盘和鼠标 -> 键盘 -> 其他布局选项 -> caps lock behavior -> caps lock is also a ctrl
```

* [更改锁屏壁纸](https://blog.csdn.net/qq_36285997/article/details/80403620)
* [开机动画](https://tianyijian.github.io/2018/04/05/ubuntu-boot-animation/#attention) [动画素材](https://www.gnome-look.org/p/1156215)

```shell
tar zvxf Paw-Ubuntu-Floral.tar.gz 
cd Paw-Ubuntu-Floral/
mv paw-ubuntu-floral.plymouth Paw-Ubuntu-Floral.plymouth

# 将Paw-Ubuntu-Floral.plymouth里/lib改为/usr/share

sudo cp -r Paw-Ubuntu-Floral /usr/share/plymouth/themes

sudo update-alternatives --install /usr/share/plymouth/themes/default.plymouth default.plymouth /usr/share/plymouth/themes/Paw-Ubuntu-Floral/Paw-Ubuntu-Floral.plymouth 100

sudo update-alternatives --config default.plysudo update-initramfs -umouth 
# 选择Paw-Ubuntu-Floral.plymouth那个

sudo update-initramfs -u
```

## 软件安装

* gcc套件

```shell
sudo apt install build-essential
```

* java

* vim
* make
* git
* vlc(媒体播放)
* [搜狗输入法](https://pinyin.sogou.com/linux/?r=pinyin)

```shell
#先安装Fcitx 和 Fcitx配置，用自带的Ubuntu软件市场安装

#fctix CPU占用100%解决 => fctix配置 -> 附加组件 -> 高级 -> 搜狗云拼音关闭
```

* [坚果云](https://www.jianguoyun.com/s/downloads)
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

* [WPS Office 2019 For Linux](https://linux.wps.cn/)(安装字体)

* [google chrome](https://www.google.com/chrome/)
  
  * [谷歌访问助手](https://github.com/haotian-wang/google-access-helper)
  
* [IDEA](https://www.jetbrains.com/idea/download/#section=linux)

* [CLion](https://www.jetbrains.com/clion/download/#section=linux)

* [QT](http://download.qt.io/archive/qt/)

  ```shell
  sudo apt install qt5-default qtcreator
  ```
