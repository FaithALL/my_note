

[toc]

## 编译(compile)

* GNU g++

  ```shell
  -o 指定文件名
  -g 把调试信息加载到可执行文件
  -E 只预处理，不生成文件，可将结果重定向到文件
  -S 只预处理和编译，生成汇编代码.s
  -c 只预处理、编译和汇编，生成对象代码(object code).o
  -l(库名) 链接库
  -x 指明使用的编程语言,可用的有c c++ assembler none, none意味根据文件扩展名猜测原文件语言
  -Wall 打开提醒、警告
  -Werror 将警告当成错误处理
  -Wextra / -W 打印一些额外的警告信息
  -isystem DIR 将DIR路径作为头文件搜索路径之一(搜索顺序: -I指定的文件夹 => -isystem指定的文件夹 => 标准系统头文件夹)
  -std=c++0x 打开对C++11的支持
  -Og 使用会生成符合原始代码整体结构的机器代码的优化等级
  ```
  
* LLVM clang++

  > clang++是编译器前端，LLVM是编译器后端

## 调试(debug)

* GNU gdb

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


## 集成开发环境

* 快捷键

```
代码格式化 Ctrl + Alt + L
```