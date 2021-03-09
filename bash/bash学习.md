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
  head {fn} -n x				#查看文件头x行
  tail {fn} -n x				#查看文件尾x行
  less {fn}					#查看文件少量内容
  
  #权限
  chmod ugo+-r/w/x {fn}		#更改user/group/other读写执行权限
  ```
  
  > `grep`正则表达式：
  >
  > * 行首`^`、行尾`$`
  > * 单个字符`.`、多个字符`*`
  > * 范围`[]`

* [shell语法](https://github.com/skywind3000/awesome-cheatsheets/blob/master/languages/bash.sh)

  ```shell
  {varname}={value}				#变量赋值，不加空格，字符串字面值加不加双引号都可
  ${varname}						#引用变量的值
  echo ${varname} "test"			#输出变量/字符串，原封不动输出echo 后的内容
  {varname}=`expr ${varname1} op ${varname2}`		#运算
  
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
  for var int range(全写或者{a...b})
  do
  	...
  done
  #while循环语句
  while [ ... ]
  do
  	...
  done
  
  #zip压缩/解压缩
  zip xxx.zip xxx/
  unzip xxx.zip
  #tar压缩/解压缩
  tar -zcvf xxx.tar.gz xxx/
  tar -zxvf xxx.tar.gz
  ```