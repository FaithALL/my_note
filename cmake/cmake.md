# [cmake学习](https://cmake.org/cmake/help/latest/guide/tutorial/index.html)

* CMakeLists.txt

  > [参考1](https://www.bilibili.com/video/BV17J411m7o1?from=search&seid=6919303658390896602)
  >
  > [参考2](https://cmake.org/cmake/help/latest/guide/tutorial/index.html)
  >
  > [参考3](https://github.com/fishCoder/CMakePractice)
  >
  > CMakeLists.txt：支持大写、小写、大小写混合

  ```cmake
  #CMake最低版本号要求
  cmake_minimum_required(VERSION num)
  #项目信息，版本名
  project(cur_project_name)
  #设置编译器选项
  set(CMAKE_CXX_FLAGS "XXX")
  #指定C++标准
  set(CMAKE_CXX_STANDARD 11)
  set(CMAKE_CXX_STANDARD_REQUIRED True)
  #设置编译模式，Debug/Release
  set(CMAKE_BUILD_TYPE "XXX")
  
  # 变量赋值
  SET(PARAM 'this is param')
  # 赋多个值个变量
  SET(PARAM main.c fun.h fun.c)
  
  #引入外部依赖
  find_package(std_lib_name VERSION REQUIRED)
  #生成库类型(动态，静态)
  add_library(<name> [lib_type] source1)
  #指定include路径，放在add_executable前面
  include_directories(${std_lib_name_INCLUDE_DIRS})
  #指定生成目标
  add_executable(cur_project_name xxx.cpp)
  #指定libraries路径，放在add_executable后面
  target_link_libraries(cur_project_name ${std_lib_name_LIBRARIES})
  
  
  #定义一个函数
  function(function_name arg)
  #添加一个子目录
  add_subdirectory(dir)
  #查找当前目录所有文件，并保存到SRC——LIST变量中
  AUX_SOURCE_DIRECTORY(. SRC_LIST)
  FOREACH(one_dir ${SRC_LIST})
  	MESSAGE(${one_dir})
  ENDFOREACH(onedir)
  
  
  # MESSAGE 		输出log
  # SEND_ERROR 	产生错误，生成过程被跳过
  # STATUS 		输出前缀为-的信息
  # FATAL_ERROR	立即终止所有cmake过程
  # ${}			取变量的值，if语句直接使用变量名
  MESSAGE(STATUS "This is BINARY dir " ${HELLO_BINARY_DIR})
  
  
  #检测当前编译平台，判断语句
  IF(WIN32)
      MESSAGE(STATUS "SYSTEM IS WIN32")
  ELSEIF(UNIX)
      MESSAGE(STATUS "SYSTEM IS UNIX")
  ELSEIF(APPLE)
      MESSAGE(STATUS "SYSTEM IS APPLE")
  ENDIF(WIN32)
  
  
  #循环
  while(condition)
  	COMMAND1(ARGS)
  endwhile(condition)
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
  
  #为源代码引入宏定义(同add_definitions(-Dmacro_name=value))
  cmake -D macro_name=value
  
  ```

  