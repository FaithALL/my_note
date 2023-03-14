# ThinkPad E580安装Arch Linux要点

## 安装(UEFI)

> [安装指引wiki](https://wiki.archlinux.org/title/Installation_guide)

* 禁用安全启动，进入live系统

* 连接互联网

* 检查时间服务状态`timedatectl status`

* 磁盘分区`fdisk`，[分区wiki](https://wiki.archlinux.org/title/Partitioning)

  * 建立GUID分区表(GPT)、分区(需要设置分区类型)、格式化分区、挂载分区、启用SWAP分区

  * 分区示例
      | 分区类型 | 大小               | 挂载点    | 格式化命令                                 | 备注         |
      | -------- | ------------------ | --------- | ------------------------------------------ | ------------ |
      | EFI分区  | 至少300MB          | /mnt/boot | `mkfs.fat -F 32 /dev/efi_system_partition` | 必须         |
      | /        | 尽可能大           | /mnt      | `mkfs.ext4 /dev/root_partition`            | 必须         |
      | SWAP     | 最好和物理内存相同 | 无        | `mkswap /dev/swap_partition`               | 推荐         |
      | /home    | 尽可能大           | /mnt/home | `mkfs.ext4 /dev/home_partition`            | 推荐另外磁盘 |
      
      > SWAP分区不需要挂载点，使用`swapon /dev/swap_partition`启用

* [设置镜像](https://wiki.archlinux.org/title/Reflector_(%E7%AE%80%E4%BD%93%E4%B8%AD%E6%96%87))，执行`reflector --country China --age 12 --sort rate --save /etc/pacman.d/mirrorlist`获取中国12小时内同步的镜像源，按下载速度排序并写入镜像文件

* 安装`pacstrap -K /mnt base linux linux-firmware base-devel vim networkmanager`

* 生成fstab文件`genfstab -U /mnt >> /mnt/etc/fstab`

* chroot到新系统`arch-chroot /mnt`

* 设置时区`ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime`并运行`hwclock --systohc`设置硬件时间

* 本地化

  * 取消`/etc/locale.gen`中`en_US.UTF-8 UTF-8`和`zh_CN.UTF-8 UTF-8`的注释
  * 运行locale-gen
  * 创建`/etc/locale.conf`文件，添加`LANG=zh_CN.UTF-8`
  
* 设置主机名、网络

  * 编辑`/etc/hostname`设置主机名，添加`{myhostname}`即可

  * 编辑`/etc/hosts`设置本地主机名解析(由systemd的NSS模块提供，设置该文件仅是为了一些应用的兼容性)

    ```config
    127.0.0.1   localhost
    ::1         localhost
    127.0.1.1   {myhostname}
    ```

* 设置Root密码`passwd`

* [安装引导程序](https://wiki.archlinux.org/title/Systemd-boot)

  * 安装微码`intel-ucode`
  
  * 安装启动管理器，`bootctl install`
  
  * 配置，`{/dev/root_partition}`代表根分区的PARTUUID，可以通过`blkid -s PARTUUID -o value /dev/root_partition`获取
  
    ```txt
    /boot/loader/loader.conf
    _______________________
    default arch
    
    /boot/loader/entries/arch.conf
    _______________________
    title    Arch Linux
    linux    /vmlinuz-linux
    initrd   /intel-ucode.img
    initrd   /initramfs-linux.img
    options  root=PARTUUID={/dev/root_partition} rw
    ```
  
* 退出chroot环境，卸载分区`umount -R /mnt`，重启，拔U盘

## 系统配置

* 普通用户
  * 创建普通用户`useradd -G {wheel} -m {username}`
  * 修改用户密码`passwd {username}`
  * 使用`visudo`取消`%{wheel} ALL=(ALL) ALL`注释，使用户可以使用sudo
  * 切换到普通用户
* 连接网络`NetworkManager`
* 启动`systemd-boot-update.service`服务，实现systemd-boot自动更新
