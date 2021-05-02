

[toc]

> c代码编译过程
>
> * C预处理器(cpp)：c文件翻译成.i文件
> * C编译器(cc1)：将.i文件翻译成汇编语言文件.s
> * 汇编器(as)：.s文件翻译成可重定位目标文件.o
> * 链接器(ld)：将.o文件以及一些必要的系统目标文件组合起来，创建可执行目标文件
> * shell中执行，将调用叫做加载器(loader)的函数

## 编译(compile)

* GNU g++(clang++兼容g++的编译选项)

  ```shell
  -o 指定文件名
  -std=c++0x 打开对C++11的支持
  -O0 不优化，默认选项
  -O1 -O2 -O3 数字越大优化等级越高，以牺牲程序可调试性为代价
  -Og 在O1基础上，去掉影响调试的优化
  -Os 在O2基础上，确定导致可执行程序增大的优化
  -g 把调试信息加载到可执行文件
  
  -E 只预处理，不生成文件，可将结果重定向到文件
  -S 只预处理和编译，生成汇编代码.s
  -c 只预处理、编译和汇编，生成对象代码(object code).o
  
  -x 指明使用的编程语言,可用的有c c++ assembler none, none意味根据文件扩展名猜测原文件语言
  -Wall 打开提醒、警告
  -Werror 将警告当成错误处理
  -Wextra / -W 打印一些额外的警告信息
  -Wl,<options> 将逗号分隔的options传递给链接器
  
  -m32 生成32位程序
  ```
  
* 头文件路径查找优先级

  * <>只在系统默认的包含路径查找
  * “”
    * 当前目录
    * -I指定目录
    * gcc的环境变量`CPLUS_INCLUDE_PATH`
    * 编译器内定路径`/usr/include`、`/usr/local/include`、`/usr/lib/gcc/x...`

## 链接(link)

> 链接器使分离编译成为可能。链接分为编译时静态链接、加载时共享库的动态链接、运行时共享库的动态链接。

* [-l选项](https://www.zhihu.com/collection/434139378)：约定生成的库文件总是以libXXX开头。在编译器通过-l参数链接库时，会寻找动态库和静态库(优先使用动态库)，比如-lpthread会自动去寻找libpthread.so和libpthread.a。如果生成的库并没有以lib开头，就不能使用-l选项，只能加在编译命令参数里的方式链接。例如g++ main.o test.so 

* [静态库&动态库](https://www.zhihu.com/collection/434139378)

  ```shell
  #静态库实质是对.o文件进行打包
  ar crsv libtest.a libtes.o
  # r 替换归档文件中已有的文件或加入新文件 (必要)
  # c 不在必须创建库的时候给出警告
  # s 创建归档索引
  # v 输出详细信息
  
  #生成动态库，也叫共享库
  g++ test.cpp -fPIC -shared -Wl,-soname,libtest.so -o libtest.so.0.1
  # shared:告诉编译器生成一个动态链接库，一般都要加上-fPIC(位置无关)
  # -Wl,-soname:指示生成的动态链接库的别名(这里是libtest.so)
  # -o:指示实际生成的动态链接库
  # 动态库有真名(libtest.so.0.1)、别名(libtest.so)和链接名(test -l时使用的)
  ```

  > 静态链接：链接阶段，会将可重定位目标文件与引用到的(静态)库模块一起链接打包到可执行文件中。未引用的模块不复制。
  >
  > 动态链接：链接阶段，会将可重定位目标文件与动态库的符号表和重定位信息链接。在运行时，加载动态库内容。linux提供了完全在运行时使用动态库的方法，`dlopen`、`dlsym`，`dlclose`、`dlerror`，详见CSAPP P487。
  >
  > 优劣：速度、体积、更新、依赖性、安全性、副本。

* 库文件路径查找优先级
  * 编译时
    * 在编译选项中写全路径
    * `-L`指定库文件搜索路径
    * 系统环境变量`LIBRARY_PATH`
    * 编译器内定路径`/lib`、`/usr/lib`、`/usr/local/lib`
  * 运行时
    * 通过`-Wl,rpath`指定的路径
    * 系统环境变量`LD_LIBRARY_PATH`
    * 配置文件`/etc/ld.so.conf`中指定的路径
    * 默认`/lib`、`/usr/lib`

## 调试(debug)

* [GNU gdb](https://github.com/skywind3000/awesome-cheatsheets/blob/master/tools/gdb.txt)

  ```shell
  #gdb调试需g++在编译时加-g选项
  gdb object                # 正常启动，加载可执行
  gdb object core           # 对可执行 + core 文件进行调试
  gdb object pid            # 对正在执行的进程进行调试
  break 101                 # 对源代码的行号设置断点
  run {args}                # 以某参数运行程序
  print                     # 打印变量的值
  next                      # 单步跳过，碰到函数不会进入
  step                      # 单步进入，碰到函数会进去
  continue                  # 一直运行到断点位置
  set var = {expression}    # 变量赋值
  set follow-fork-mode mode # 在fork后执行父进程或子进程，mode可选parent、child
  info threads              # 显示可调试的所有线程
  thread id                 # 调试目标id指定的线程
  ```
  
  >linux下调试错误
  >
  >```shell
  >ulimit -c unlimited		#设置可以生成core文件
  >gcc -g test.c			#编译时加-g选项
  >gdb ./a.out ./core		#开启调试
  >where					#gdb中查询位置
  >```

## 运行(run)

* 运行

  ```shell
  #application是编译出的可执行文件
  ./application
  ```

* 文件重定向

  ```shell
  #将infile作为标准输入，outfile作为标准输出
  ./application <infile >outfile
  ```


## 测试(test)

* valgrind

* google test

  ```shell
  #安装
  git clone git@github.com:google/googletest.git
  #进入项目目录后
  mkdir build 
  cd build && cmake ..
  make
  sudo make install
  ```

  