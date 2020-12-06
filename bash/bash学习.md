* bash配置文件

  * 按范围
    * 全局生效：`/etc/profile`、`/etc/profile.d/*.sh`、`/etc/.bashrc`
    * 个人用户生效：`~/.bash_profile`、`~/.bashrc`
  * 按功能
    * profile：用于定义环境变量，运行命令或脚本
    * bashrc：用于别名、函数、本地变量
  
* 常用，[参考1](https://gohom.win/2016/03/22/bash-twinkle/)，[参考2](https://zh.wikipedia.org/wiki/ANSI%E8%BD%AC%E4%B9%89%E5%BA%8F%E5%88%97)
  
  ```bash
  #使用闪烁的|
  echo -ne "\e[5;6 q"
  ```