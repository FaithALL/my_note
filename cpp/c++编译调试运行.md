

[toc]

## 编译(compile)

* GNU g++

  ```shell
  -o 指定文件名
  -E 只预处理，不生成文件，可将结果重定向到文件
  -S 只预处理和编译，生成汇编代码.s
  -c 只预处理、编译和汇编，生成对象代码(object code).o
  -Wall 打开提醒、警告
  -std=c++0x 打开对C++11的支持
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