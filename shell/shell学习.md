* bash配置文件

  * 按范围
    * 全局生效：`/etc/profile`、`/etc/profile.d/*.sh`、`/etc/bashrc`
    * 个人用户生效：`~/.profile`、`~/.bashrc`
    
  * 按功能
    * profile：用于定义环境变量，运行命令或脚本
    * bashrc：用于别名、函数、本地变量
    
  * 常用，[参考1](https://gohom.win/2016/03/22/bash-twinkle/)，[参考2](https://zh.wikipedia.org/wiki/ANSI%E8%BD%AC%E4%B9%89%E5%BA%8F%E5%88%97)
    
    ```shell
    #使用闪烁的|
    echo -ne "\e[5;6 q"
    #显示环境变量
    env
    #修改环境变量
    #当前终端有效
    export PATH=$PATH:/tmp/test
    #将上述语句放到bash配置文件，永久生效
    
    #重新加载，读取并执行file中的命令
    source {file}
    ```
  
* [常用命令](https://github.com/skywind3000/awesome-cheatsheets/blob/master/languages/bash.sh)

  ```shell
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
  
  #网络
  telnet {ip} {port}            #socket连接ip::port
  dig {domain}                  #获取域名dns信息
  host {domain}                 #获取域名ip
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
  lsof -Pni                 #查看打开的socket,i指定网络相关，P使用端口,n使用ip
  nc -v {ip} {port}         #模拟客户端连接ip::port
  nc -v -l {ip} {port}      #模拟服务端监听ip::port
  #netcat默认以\n为每次消息结束标志，-C选项指定结束标志为\r\n
  #用>和<来收发文件
  
  #文件
  grep {pat} {fn}           #在文件中查找出现过 pat 的内容
  stat {fn}                 #显示文件的详细信息
  wc -l {fn}                #统计文件有多少行，多少个单词
  split -l {cnt} {old} {new}#按行拆分文件
  head {fn} -n x            #查看文件头x行
  tail {fn} -n x            #查看文件尾x行
  less {fn}                 #查看文件少量内容
  find -name filename 2>/dev/null   #查找文件(过滤无权限提示)
  sed -i 's/old/new/g' {fn}         #全文将old替换为new
  awk 'print $1,$4' {fn}            #打印文本中的第1、4项
  
  #权限
  chmod ugo+-r/w/x {fn}     #更改user/group/other读写执行权限
  
  #[解]压缩
  zip xxx.zip xxx/          #zip压缩
  unzip xxx.zip             #zip解压缩
  tar -zcvf xxx.tar.gz xxx/ #tar压缩
  tar -zxvf xxx.tar.gz      #tar解压缩
  
  ```

  > `grep`正则表达式：
  >
  > * 行首`^`、行尾`$`
  > * 单个字符`.`、多个字符`*`
  > * 范围`[]`

* [shell语法](https://github.com/skywind3000/awesome-cheatsheets/blob/master/languages/bash.sh)

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
