## GCC

[编译器驱动程序](#编译器驱动程序)

[常用选项](#常用选项)

[预处理器](#预处理器(cpp))

[链接器](#链接器(ld))

### 编译器驱动程序

* 编译器驱动程序：预处理器、编译器、汇编器和链接器。
* C语言从源代码到可执行目标文件的流程：
  * C预处理器(cpp)：将源文件翻译成.i文件。
  * C编译器(cc1)：将.i文件翻译成汇编语言文件.s。如果是C++对应的编译器就是cc1plus。
  * 汇编器(as)：将.s文件翻译成可重定位目标文件.o。
  * 链接器(ld)：将.o文件以及一些必要的系统目标文件组合起来，创建可执行目标文件。
  * shell中执行：将调用一个叫做加载器(loader)的函数，它将可执行文件的代码和数据复制到内存中，然后将控制转移到这个程序的开头。

### 常用选项

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
-Werror=return-type 检查是否漏写return
-Werror=maybe-uninitialized 检查是否初始化

-v 打印命令运行阶段相关配置信息

-m32 生成32位程序
-masm=intel 生成intel风格的汇编代码(要加-S选项)
-mavx2 生成AVX2汇编代码
```

### 预处理器(cpp)

* [头文件搜索路径优先级](https://gcc.gnu.org/onlinedocs/cpp/Search-Path.html)
  * 当前相对目录(仅对`""`包裹的头文件)
  * `-Idir`、`-isystem`等[编译选项](https://gcc.gnu.org/onlinedocs/gcc-7.2.0/gcc/Directory-Options.html#Directory-Options)从左到右
  * `C_INCLUDE_PATH`、`CPLUS_INCLUDE_PATH`等[环境变量](https://gcc.gnu.org/onlinedocs/gcc-7.2.0/gcc/Environment-Variables.html#Environment-Variables)
  * 默认系统目录
    * 可以使用`cpp -v /dev/null -o /dev/null`查看。
    * 一般有`/usr/local/include`、`/usr/include/x86_64-linux-gnu`、`/usr/include`等。
    * 在编译操作系统内核时，可以使用`-nostdinc`禁止使用默认系统目录。

### 链接器(ld)

* `ldd`命令可以查看一个共享库或者可执行文件依赖的共享库。

* [-l选项](https://zhuanlan.zhihu.com/p/151219726)：约定生成的库文件总是以libXXX开头。在编译器通过-l参数链接库时，会寻找动态库和静态库(优先使用动态库)，比如-lpthread会自动去寻找libpthread.so和libpthread.a。如果生成的库并没有以lib开头，就不能使用-l选项，只能加在编译命令参数里的方式链接。例如g++ main.o test.so 

* [静态库&动态库](https://zhuanlan.zhihu.com/p/151219726)

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