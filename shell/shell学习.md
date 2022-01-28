* 内建命令和外部命令

  * 内建命令是shell程序的一部分，通常在系统加载运行时就被加载并驻留系统内存中。执行速度比外部命令快，也不需要创建子进程。
  * 外部命令是文件系统中的可执行文件，在`PATH`环境变量的路径下可以找到，执行需要创建新进程。
  * `type`命令可以识别外部命令和内建命令。
  
* [bash/zsh的四种运行模式](https://zhuanlan.zhihu.com/p/47819029)

  * 交互模式：用于接受用户命令
  
  * 非交互模式：用于执行一段脚本
  
  * 登录模式：终端登陆、ssh连接、`su --login <username>`切换用户
  
  * 非登录模式：直接运行bash时，`su <username>`切换用户时
  
  * 四种模式组合会有配置文件加载的差异
  
    <div align=center><img width="407" height="427" src="https://www.solipsys.co.uk/images/BashStartupFiles1.png"/></div>
  
* [常用命令](https://github.com/skywind3000/awesome-cheatsheets/blob/master/languages/bash.sh)

  ```shell
  #内建命令
  history                       #显示最近使用的命令
  alias -p                      #查看当前命令别名
  export name=value             #在当前shell及子进程导出为环境变量
  
  #开发相关
  ./app <infile >outfile         #运行程序，重定向IO
  objdump -d filename            #反汇编
  valgrind --tool=memcheck ./app #检查程序内存问题
  gprof ./app                    #分析程序性能，需要-pg编译选项
  
  #SSH配置文件在.ssh/config
  ssh user@host                 #以用户user登录到远程主机host
  ssh -p {port} user@host       #以指定端口登录
  ssh-copy-id user@host         #拷贝本机ssh公钥到远程主机，避免重复输入密码
  scp {fn} user@host:path       #拷贝文件到远程主机
  
  #系统信息
  uname -a                      #查看内核版本等信息
  uptime                        #查看系统当前时间、运行时间、负载等信息
  top                           #查看CPU(t)、内存(m)占用
  pstack {pid}                  #查看进程的线程数量和线程调用栈
  strace -p {pid}               #查看进程动态信息
  systemctl enable/disable/stop/start/restart/mask/unmask {name}
  
  #网络
  telnet {ip} {port}            #socket连接ip::port
  dig {domain}                  #获取域名dns信息
  host {domain}                 #获取域名ip
  ifconfig/ip                   #查看网络配置相关信息
  route                         #网络路由相关
  iptables                      #数据包过滤转发相关(四表五链)
  tcpdump   -i lo               #指定网卡为lo(本地回环)
  #指定主机       host {ip} 
  #指定源主机     src host {ip}
  #指定目的主机   dst host {ip}
  #指定端口       port {number}
  #指定抓包数     -c {number}
  #显示16进制格式 -X
  #显示时间戳     -t
  #不解析主机名和端口名 -n
  netstat -a                    #列出所有监听和非监听状态的连接
  #列出进程进程信息     -p
  #指定udp\tcp          -u\-t
  #不解析主机名和端口名 -n
  lsof -Pni                 #查看打开的socket,i指定网络相关，P使用端口，n使用ip
  nc -v {ip} {port}         #模拟客户端连接ip::port
  nc -v -l {ip} {port}      #模拟服务端监听ip::port
  #netcat默认以\n为每次消息结束标志，-C选项指定结束标志为\r\n
  #用>和<来收发文件
  
  #文件
  grep {pat} {fn}           #在文件中查找pat的位置，-i忽略大小写，-r递归查找，-n显示行号
  stat {fn}                 #显示文件的详细信息
  wc -l {fn}                #统计文件有多少行，多少个单词
  split -l {cnt} {old} {new}#按行拆分文件
  head {fn} -n x            #查看文件头x行
  tail {fn} -n x            #查看文件尾x行
  less {fn}                 #查看文件少量内容
  find -name filename 2>/dev/null   #查找文件(过滤无权限提示)
  sed -i 's/old/new/g' {fn}         #全文将old替换为new
  awk '{print $1,$4}' {fn}          #打印文本中的第1、4项
  
  #文件系统和磁盘
  du -h {dir}               #查看目录磁盘大小(含文件)
  df -h                     #查看文件系统容量、使用、挂载点等信息
  fdisk -l                  #查看磁盘分区(表)信息
  
  #权限
  chmod ugo+-r/w/x {fn}     #更改user/group/other读写执行权限
  
  #[解]压缩
  zip xxx.zip xxx/          #zip压缩
  unzip xxx.zip             #zip解压缩
  tar -zcvf xxx.tar.gz xxx/ #tar压缩
  tar -zxvf xxx.tar.gz      #tar解压缩
  
  #定时任务
  crontab [-u user] {-l | -r | -e}
  
  #wifi、蓝牙、设备
  lsmod                    #查看内核模块
  modprobe -r <name>       #删除内核模块
  modprobe <name>          #加载内核模块
  lspci                    #显示pci设备
  lsusb                    #显示usb设备
  rfkill list              #查看蓝牙和wifi设备列表
  hciconfig -a             #查看蓝牙设备信息
  iwconfig/iw              #查看无线网卡wifi信息
  ```

  > `grep`正则表达式：
  >
  > * 行首`^`、行尾`$`
  > * 单个字符`.`、多个字符`*`
  > * 范围`[]`

* [bash语法](https://github.com/skywind3000/awesome-cheatsheets/blob/master/languages/bash.sh)

  > [参考](https://www.junmajinlong.com/shell/index/)

  ```shell
  {varname}={value}                 #变量赋值，不加空格，字符串字面值加不加双引号都可
  ${varname}                        #引用变量的值
  echo ${varname} "test"            #输出变量/字符串，原封不动输出echo 后的内容
  {varname}=`expr ${varname1} op ${varname2}`       #运算
  # 执行cmd命令
  `cmd`
  $(cmd)
  
  #数字比较符号<、>、=、<=、>=、!=
  #l:less、t:than、g:greater、e:euqual、n:not
  -lt、-gt、-eq、-le、-ge、-ne
  #字符串比较=、!=
  #字符串拼接"$str1 $str2"
  #字符串为空-z、字符串非空-n
  #数组
  {varname}=(...)
  #if语句
  if [ ... ]
  then
    ...
  else
    ...
  fi
  
  #for循环语句
  for var in range(全写或者{a..b})
  do
    ...
  done
  # for循环
  for ((expr1;expr2;expr3))
  do
  ...
  done
  
  #while循环语句
  while [ ... ]
  do
    ...
  done
  
  # shell函数
  function func_name() {CMD_LIST}
  function func_name {CMD_LIST}
  func_name() {CMD_LIST}
  ```
