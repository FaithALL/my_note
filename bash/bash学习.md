* bash配置文件

  * 按范围
    * 全局生效：`/etc/profile`、`/etc/profile.d/*.sh`、`/etc/.bashrc`
    * 个人用户生效：`~/.bash_profile`、`~/.bashrc`
    
  * 按功能
    * profile：用于定义环境变量，运行命令或脚本
    * bashrc：用于别名、函数、本地变量
    
  * 常用，[参考1](https://gohom.win/2016/03/22/bash-twinkle/)，[参考2](https://zh.wikipedia.org/wiki/ANSI%E8%BD%AC%E4%B9%89%E5%BA%8F%E5%88%97)
    
    ```shell
    #使用闪烁的|
    echo -ne "\e[5;6 q"
    ```
  
* [常用命令](https://github.com/skywind3000/awesome-cheatsheets/blob/master/languages/bash.sh)

  ```shell
  #SSH配置文件在.ssh/config
  ssh user@host				#以用户user登录到远程主机host
  ssh -p {port} user@host		#以指定端口登录
  ssh-copy-id user@host		#拷贝本机ssh公钥到远程主机，避免重复输入密码
  scp {fn} user@host:path		#拷贝文件到远程主机
  
  #系统信息
  uname -a					#查看内核版本等信息
  
  #网络
  dig {domain}				#获取域名dns信息
  
#文件
  grep {pat} {fn}             #在文件中查找出现过 pat 的内容
  stat {fn}           		#显示文件的详细信息
  wc {fn}             		#统计文件有多少行，多少个单词
  ```
  
  

