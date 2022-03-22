# [cmake学习](https://cmake.org/cmake/help/latest/guide/tutorial/index.html)

* 学习资料

  > [b站视频](https://www.bilibili.com/video/BV16P4y1g7MH/?spm_id_from=333.788)
  >
  > [PROJECT变量和CMAKE变量的区别](https://stackoverflow.com/questions/32028667/are-cmake-source-dir-and-project-source-dir-the-same-in-cmake)、[cmake预置变量](https://cmake.org/cmake/help/latest/manual/cmake-variables.7.html)
  >
  > [find_package原理](https://zhuanlan.zhihu.com/p/97369704)
  >
  > [PUBLIC、PRIVATE、INTERFACE区别](https://zhuanlan.zhihu.com/p/82244559)、[理解PUBLIC、PRIVATE、INTERFACE](https://www.ravenxrz.ink/archives/e40194d1.html?utm_source=wechat_session&utm_medium=social&utm_oi=1114168747400679424)
  >
  > [add_custom_target和add_custom_command的区别](https://blog.csdn.net/qq_38410730/article/details/102797448)
  >
  > CMakeLists.txt：指令、函数名不分大小写，但变量名、指令中的参数、文件名区分大小写

* 起手式

  ```cmake
  #CMake最低版本号要求
  cmake_minimum_required(VERSION num)
  #项目信息，版本名
  project(cur_project_name VERSION num)
  ```

* 变量

  * 普通变量`set(<variable> <value>... [PARENT_SCOPE])`

    * `${variable}`首先找普通变量，如果找不到会找缓存变量

    * `add_subdirectory()`和`function()`属于拷贝父模块的变量到当前模块作用域，如果`set`不加`PARENT_SCOPE`，变量的修改不会传递到父模块

    * `include()`和`macro()`属于将代码复制到当前位置，可以修改当前模块的变量

      ```cmake
      #设置编译器选项
      set(CMAKE_CXX_FLAGS "XXX")
      #指定C++标准
      set(CMAKE_CXX_STANDARD 11)
      set(CMAKE_CXX_STANDARD_REQUIRED ON)

  * 缓存变量`set(<variable> <value>... CACHE <type> <docstring> [FORCE])`

    * `$CACHE{variable}`

    * 全局可见，会写入`CMakeCache.txt`文件中

    * 如果有与缓存变量同名的普通变量，在此之后都以普通变量为准

    * 修改缓存变量可以通过`set`(如果缓存变量已经存在但不加`FORCE`就不能修改)或者cmake的`-D<var>=value`选项

    * `BOOL`类型的缓存变量可以使用`option(<variable> <docstring> ON/OFF)`来设置

      ```shell
      #设置/修改缓存变量
      cmake -DVAR=VALUE ...
      #将编译命令写入compile_commands.json
      cmake -B build -DCMAKE_EXPORT_COMPILE_COMMANDS=ON 
      #指定编译模式
      cmake -B build -DCMAKE_BUILD_TYPE=Release/Debug/...
      #指定安装目录
      cmake -B build -DCMAKE_INSTALL_PREFIX=PATH

  * 环境变量

    * `$ENV{variable}`
    * 设置当前进程环境变量`set(ENV{<variable>} <value>...)`

* target和属性

  ```cmake
  #指定生成库文件(动态，静态)
  add_library(target_name [lib_type] source_file)
  #指定生成可执行文件
  add_executable(target_name source_file)
  
  #为构建目标自定义一个命令
  add_custom_command(OUTPUT output
      COMMAND command [args ...] ...)
  #设置一个没有输出的target，使它总是构建
  add_custom_target(target_name
      COMMAND command [args ...] ...
      DEPENDS depend ...)
  
  
  #给target设置属性
  set_target_properties(target_name PROPERTIES 
      ...   ...)
  #给target添加源文件
  target_sources(target_name source_file)
  #指定include路径
  include_directories(${std_lib_name_INCLUDE_DIRS})
  #给target指定include路径
  target_include_directories(target_name ${std_lib_name_INCLUDE_DIRS})
  #给target指定libraries
  target_link_libraries(target_name ${std_lib_name_LIBRARIES})
  #添加宏定义
  add_definitions(var=value)
  #给target添加宏定义
  target_add_definitions(target_name var=value)
  #给target添加编译选项
  target_compile_options(target_name ...)
  
  
  #构建子目录，输出目录(binary_dir)可选
  add_subdirectory(source_dir [binary_dir])
  ```

* find

  ```cmake
  #查找头文件路径
  find_path(std_lib_name_INCLUDE_DIRS name path)
  #查找库文件路径
  find_library(std_lib_name_LIBRARIES name path)
  #引入外部依赖
  find_package(std_lib_name VERSION REQUIRED)
  
  #查找当前目录所有(不递归)源文件，保存到SRC_LIST变量中
  aux_source_directory(. src_list)
  #类似的命令有file(GLOB src_list CONFIGURE_DEPENDS *.cpp *.h)
  #递归查找file(GLOB_RECURSE src_list CONFIGURE_DEPENDS *.cpp *.h)

* 控制语句

  ```cmake
  # 输出          字符串是否写双引号都可以
  # MESSAGE 		输出log
  # WARNING       警告
  # STATUS 		输出前缀为-的信息
  # FATAL_ERROR	立即终止所有cmake过程
  # SEND_ERROR 	产生错误，生成过程被跳过
  message(STATUS "This is var: ${var}")
  
  #定义一个函数
  function(function_name arg)
       ...
  endfunction()
  
  #if语句，检测当前编译平台，if语句直接使用变量名不需要${}
  if(WIN32)
      message(STATUS "SYSTEM IS WIN32")
  elseif(APPLE)
      message(STATUS "SYSTEM IS APPLE")
  elseif(UNIX)
      message(STATUS "SYSTEM IS UNIX")
  endif(WIN32)
  #检查是否定义了某普通/缓存变量if(DEFIND VAR)
  #判断变量是否为空字符串if(VAR)
  
  #while循环
  while(condition)
  	COMMAND1(ARGS)
  endwhile(condition)
  
  #for循环
  foreach(one_dir ${SRC_LIST})
  	message(${one_dir})
  endforeach(one_dir)
  ```

* 引入第三方库

  ```cmake
  include(FetchContent)
  FetchContent_Declare(
    googletest
    GIT_REPOSITORY https://github.com/google/googletest.git
    GIT_TAG        703bd9caab50b139428cea1aaff9974ebee5742e # release-1.10.0
  )
  FetchContent_Declare(
    myCompanyIcons
    URL      https://intranet.mycompany.com/assets/iconset_1.12.tar.gz
    URL_HASH MD5=5588a7b18261c20068beabfb4f530b87
  )
  
  FetchContent_MakeAvailable(googletest myCompanyIcons)
  
* cmake命令

  ```shell
  #配置生成过程
  cmake -B build
  #编译链接，相当于make -C build -j4
  cmake --build build -j4
  #执行
  ./build/target_name
  
  #指定生成器
  cmake -G generator_name
  ```

  