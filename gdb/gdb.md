
* [GNU gdb](https://github.com/skywind3000/awesome-cheatsheets/blob/master/tools/gdb.txt)

  ```shell
  #gdb调试需g++在编译时加-g选项
  gdb object                # 正常启动，加载可执行
  gdb object core           # 对可执行 + core 文件进行调试
  gdb object pid            # 对正在执行的进程进行调试
  break {lineno}            # 对源代码的行号设置断点
  break {funcname}          # 在函数入口处设置断点
  break * {addr}            # 在地址处设置断点
  delete 1                  # 删除断点1
  run {args}                # 以某参数运行程序
  print                     # 打印变量的值
  next                      # 单步跳过，碰到函数不会进入
  nexti                     # 执行1条指令，碰到函数不会进入
  step                      # 单步进入，碰到函数会进去
  stepi                     # 执行1条指令
  finish                    # 运行到当前函数返回
  continue                  # 一直运行到断点位置
  disas                     # 反汇编当前函数
  disas {funcname}          # 反汇编函数funcname
  where/bt                  # 查看调用栈
  set var = {expression}    # 变量赋值
  set follow-fork-mode mode # 在fork后执行父进程或子进程，mode可选parent、child
  info break                # 显示断点信息
  info threads              # 显示可调试的所有线程
  info frame                # 显示有关当前栈帧信息
  info registers            # 显示所有寄存器的值
  thread apply all bt       # 打印所有线程调用栈
  thread id                 # 调试目标id指定的线程
  shell clear               # 清空屏幕
  list                      # 显示对应的源文件
  x/s $rdi                  # 以字符串形式检查rdi所指的地址内容
  ```
  
  >linux下调试段错误
  >
  >```shell
  >ulimit -c unlimited	    #设置可以生成core文件
  >#文件/proc/sys/kernel/core_pattern控制core文件生成位置
  >#ubuntu的apport会在上述文件拦截core，可以关掉
  >gcc -g test.c           #编译时加-g选项，编译运行后可以生成core文件
  >gdb ./a.out ./core      #开启调试
  >where                   #gdb中查询位置
  >```

