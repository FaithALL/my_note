# [cmake学习](https://cmake.org/cmake/help/latest/guide/tutorial/index.html)

* CMakeLists.txt

  > [参考1](https://www.bilibili.com/video/BV17J411m7o1?from=search&seid=6919303658390896602)
  >
  > [参考2](https://cmake.org/cmake/help/latest/guide/tutorial/index.html)
  >
  > [参考3](https://github.com/fishCoder/CMakePractice)
  >
  > [系统默认的cmake变量](https://gitlab.kitware.com/cmake/community/-/wikis/doc/cmake/Useful-Variables)
  >
  > [PROJECT变量和CMAKE变量的区别](https://stackoverflow.com/questions/32028667/are-cmake-source-dir-and-project-source-dir-the-same-in-cmake)
  >
  > [find_package原理](https://zhuanlan.zhihu.com/p/97369704)
  >
  > [PUBLIC、PRIVATE、INTERFACE区别](https://zhuanlan.zhihu.com/p/82244559)
  >
  > CMakeLists.txt：支持大写、小写、大小写混合

  ```cmake
  #CMake最低版本号要求
  cmake_minimum_required(VERSION num)
  #项目信息，版本名
  project(cur_project_name VERSION num)
  
  #设置编译器选项
  set(CMAKE_CXX_FLAGS "XXX")
  #指定C++标准
  set(CMAKE_CXX_STANDARD 11)
  set(CMAKE_CXX_STANDARD_REQUIRED ON)
  #设置编译模式，Debug/Release
  set(CMAKE_BUILD_TYPE "XXX")
  # 变量赋值
  set(PARAM 'this is param')
  # 赋多个值个变量
  set(PARAM main.c fun.h fun.c)
  
  
  #查找头文件路径
  find_path(std_lib_name_INCLUDE_DIRS name path)
  #查找库文件路径
  find_library(std_lib_name_LIBRARIES name path)
  #引入外部依赖
  find_package(std_lib_name VERSION REQUIRED)
  
  #查找当前目录所有(不递归)源文件，保存到SRC_LIST变量中
  aux_source_directory(. SRC_LIST)
  
  #指定生成库文件(动态，静态)
  add_library(target_name [lib_type] source_file)
  #指定生成可执行文件
  add_executable(target_name source_file)
  
  #指定include路径
  include_directories(${std_lib_name_INCLUDE_DIRS})
  #按target指定include路径
  target_include_directories(target_name ${std_lib_name_INCLUDE_DIRS})
  #指定libraries路径
  target_link_libraries(target_name ${std_lib_name_LIBRARIES})
  
  #构建子目录，输出目录(binary_dir)可选
  add_subdirectory(source_dir [binary_dir])
  
  
  # 输出
  # MESSAGE 		输出log
  # SEND_ERROR 	产生错误，生成过程被跳过
  # STATUS 		输出前缀为-的信息
  # FATAL_ERROR	立即终止所有cmake过程
  # ${}			取变量的值，if语句直接使用变量名
  message(STATUS "This is BINARY dir " ${HELLO_BINARY_DIR})
  
  #定义一个函数
  function(function_name arg)
  
  #if语句，检测当前编译平台
  if(WIN32)
      message(STATUS "SYSTEM IS WIN32")
  elseif(UNIX)
      message(STATUS "SYSTEM IS UNIX")
  elseif(APPLE)
      message(STATUS "SYSTEM IS APPLE")
  endif(WIN32)
  
  #while循环
  while(condition)
  	COMMAND1(ARGS)
  endwhile(condition)
  
  #for循环
  foreach(one_dir ${SRC_LIST})
  	message(${one_dir})
  endforeach(one_dir)
  ```

* cmake参数

  ```shell
  #构建过程
  mkdir build
  cd build
  cmake ../src
  #编译链接
  cmake --build .
  #执行
  ./project_name
  
  #定义变量
  cmake -D var=value
  #cmake -D CMAKE_EXPORT_COMPILE_COMMANDS=ON 将编译命令写入compile_commands.json
  #指定生成器
  cmake -G generator_name
  ```
  
  