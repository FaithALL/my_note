"===========基本==============
set nocompatible	"关闭vi兼容模式
set wildmenu		"开启vim自身命令行智能补全
set mouse=a         "可用鼠标
set encoding=utf-8	"设置编码
set timeout timeoutlen=1000 ttimeoutlen=100
                    "修改延迟,详细请看:help timeoutlen


"===========缩进相关==========
filetype indent on	"开启文件类型检查并自适应不同语言智能缩进
set autoindent      "按下回车,保持和上一行一样的缩进
set expandtab		"将Tab扩展成空格
set tabstop=4		"按下Tab键时,显示的空格数
set shiftwidth=4	"设置格式化时,Tab占用的空格数
set softtabstop=4	"把连续的空格视为Tab


"===========显示==============
syntax enable		"开启语法高亮
syntax on		    "允许指定语法高亮代替默认方案
set number		    "显示行号
set showmode        "显示当前处于命令模式还是插入模式
set showcmd         "显示当前指令
set showmatch       "高亮括号另一半
set cursorline		"高亮当前行
set incsearch		"开启实时搜索,跳到第一个匹配项
set ignorecase		"搜索时忽略大小写
set hlsearch		"高亮显示搜索结果

"set foldmethod=syntax	"基于语法进行代码折叠
"set nofoldenable	    "启动vim时关闭代码折叠

"===========内置终端==========
"设置内置终端快捷键,在下方打开若干行的终端窗口
map <C-i> :below terminal ++rows=8<CR>

"======================vim-plug插件=========================
call plug#begin('~/.vim/plugged')			                        "vim-plug插件管理
    Plug 'dracula/vim',{'as': 'dracula' }			                "主题
    Plug 'octol/vim-cpp-enhanced-highlight',{'for':['c','cpp']}     "语法高亮
    Plug 'valloric/youcompleteme',{'for':['c','cpp','python'], 'do': 
                \ 'cd ~/.vim/plugged/youcompleteme/ && python3 install.py --clangd-completer'} "自动补全
    Plug 'Raimondi/delimitMate'	                                    "括号补全
call plug#end()


"====================主题插件,修改配色方案==================
"colorscheme dracula


"======================语法高亮插件=========================
let g:cpp_class_decl_highlight = 1      "高亮显示声明中的类名
let g:cpp_class_scope_highlight = 1     "高亮显示::之前的类名


"======================自动补全插件=========================
"加载默认配置文件
"let g:ycm_global_ycm_extra_conf='~/.vim/.ycm_extra_conf.py'

"使用自定义.ycm_extra_conf.py时不询问
"let g:ycm_confirm_extra_conf=0
"两个字母就触发语义补全
let g:ycm_semantic_triggers =  {
			\ 'c,cpp,python': ['re!\w{2}'],
			\ }
"候选补全区的颜色
highlight PMenu ctermfg=0 ctermbg=242 guifg=black guibg=darkgrey
highlight PMenuSel ctermfg=242 ctermbg=8 guifg=darkgrey guibg=black
"补全内容不以分割子窗口形式出现,只显示补全列表
set completeopt-=preview
"避免分析白名单以外的文件类型
let g:ycm_filetype_whitelist={
            \"c":1,
            \"cpp":1,
            \"python":1
            \}
"屏蔽YCM的诊断信息
"let g:ycm_show_diagnostics_ui = 0
