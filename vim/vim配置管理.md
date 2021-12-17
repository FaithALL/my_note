# vim配置管理

* `za`打开或关闭当前代码折叠，`zm`关闭所有折叠，`zr`打开所有折叠

* [vim-plug](https://github.com/junegunn/vim-plug/)(插件管理)

  ```shell
  PlugStatus	检查plug负责的插件状态
  PlugInstall 安装配置好的插件
  PlugUpdate 更新已经安装好的插件
  PlugClean 清理插件
  PlugUpgrade 升级自身
  #.vimrc里
  call plug#begin('~/.vim/plugged')       "指定插件安装目录
  Plug 'x/y'                              "获取插件https://github.com/x/y
  call plug#end()
  ```

  | 选项 | 描述                                       |
  | ---- | ------------------------------------------ |
  | as   | 为插件目录使用其他名称                     |
  | on   | 按commands或<Plug>-mappings加载            |
  | for  | 按文件类型加载                             |
  | do   | 在更新后执行(更新后有的插件需要额外的步骤) |

* [Dracula](https://draculatheme.com/vim/)(主题)

  ```shell
Plug 'dracula/vim',{'as': 'dracula' } 
  ```

* [vim-cpp-enhanced-highlight](https://github.com/octol/vim-cpp-enhanced-highlight)(c++语法高亮)

  ```shell
  Plug 'octol/vim-cpp-enhanced-highlight',{'for':['c','cpp']}
  ```

* [youcompleteme](https://github.com/ycm-core/YouCompleteMe)(自动补全)

  > YCM是具有已编译组件的插件。如果更新YCM，并且ycm_core库API已更改，则YCM会通知重新编译。然后，需要重新运行安装过程。

  * 安装编译工具

    ```shell
    sudo apt install build-essential cmake python3-dev
    ```

  * 在.vimrc里添加

    ```shell
    Plug 'valloric/youcompleteme',{'for':['c','cpp']}
    ```

  * 在vim里 `:PlugInstall`

  * 为c系语言编译ycm_core

    ```shell
    cd ~/.vim/plugged/youcompleteme/
    git submodule update --init --recursive
    #c-family 和 go
    python3 install.py --clangd-completer --go-completer 
    ```
    
    | 选项              | 快捷键        |
    | ----------------- | ------------- |
    | 向前/向后浏览选项 | Tab/Shift Tab |

