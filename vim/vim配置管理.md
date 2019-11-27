# vim配置管理

* [vim-plug](https://github.com/junegunn/vim-plug/)(插件管理)

```vim
PlugStatus	检查plug负责的插件状态
PlugInstall 安装配置好的插件
PlugUpdate 更新已经安装好的插件
PlugClean 清理插件
PlugUpgrade 升级自身
```

* [youcompleteme](https://github.com/ycm-core/YouCompleteMe)

  > 用vim-plug安装youcompleteme，提供c++开发环境

  * 在.vimrc里添加

    ```
    call plug#begin('~/.vim/plugged')
    Plug 'valloric/youcompleteme',{'for':['c','cpp']}
    call plug#end()
    ```

  * 在vim里 :PlugInstall

  * 为c系语言编译ycm_core

    ```shell
    cd ~/.vim/plugged/youcomplete/
    git submodule update --init --recursive
    python3 install.py --clang-completer
    ```
    
  * 配置youcompleteme，详见[知乎](https://www.zhihu.com/question/47691414/answer/373700711)


