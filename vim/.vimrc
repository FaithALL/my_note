set nocompatible	"关闭vi兼容模式
set wildmenu		"开启vim自身命令行智能补全
set mouse=a         "可用鼠标

"修改延迟,详细请看:help timeoutlen
set timeout timeoutlen=1000 ttimeoutlen=100

set encoding=utf-8	"设置编码
set number		    "显示行号

filetype indent on	"自适应不同语言智能缩进
set expandtab		"将制表符扩展成空格
set tabstop=4		"设置编辑时制表符占用的空格数
set shiftwidth=4	"设置格式化时制表符占用的空格数
set softtabstop=4	"把连续的空格视为制表符

syntax enable		"开启语法高亮
syntax on		    "允许指定语法高亮代替默认方案
set cursorline		"高亮当前行
set incsearch		"开启实时搜索
set ignorecase		"搜索时忽略大小写
set hlsearch		"高亮显示搜索结果

"set foldmethod=syntax	"基于语法进行代码折叠
"set nofoldenable	    "启动vim时关闭代码折叠



call plug#begin('~/.vim/plugged')			                    "vim-plug插件管理
    Plug 'dracula/vim',{'as': 'dracula' }			            "主题
    Plug 'octol/vim-cpp-enhanced-highlight',{'for':['c','cpp']}	"语法高亮
    Plug 'valloric/youcompleteme',{'for':['c','cpp']}	        "自动补全
call plug#end()


"主题插件,修改配色方案  
colorscheme dracula

"语法高亮插件
let g:cpp_class_decl_highlight = 1      "高亮显示声明中的类名
let g:cpp_class_scope_highlight = 1     "高亮显示::之前的类名


"自动补全插件
"根据不同的文件类型加载默认配置文件
autocmd FileType cpp 
    \ let g:ycm_global_ycm_extra_conf='~/.ycm_extra_conf/cpp/.ycm_extra_conf.py'
autocmd FileType c 
    \ let g:ycm_global_ycm_extra_conf='~/.ycm_extra_conf/c/.ycm_extra_conf.py'

"使用自定义.ycm_extra_conf.py时不询问
"let g:ycm_confirm_extra_conf=0
"两个字母就触发语义补全
let g:ycm_semantic_triggers =  {
			\ 'c,cpp': ['re!\w{2}'],
			\ }
"候选补全区的颜色
highlight PMenu ctermfg=0 ctermbg=242 guifg=black guibg=darkgrey
highlight PMenuSel ctermfg=242 ctermbg=8 guifg=darkgrey guibg=black
"补全内容不以分割子窗口形式出现,只显示补全列表
set completeopt-=preview
"关闭函数原型预览(感觉效果和上一个一样)
"set completeopt=menu,menuone
"let g:ycm_add_preview_to_completeopt = 0
"避免分析白名单以外的文件类型
let g:ycm_filetype_whitelist={
            \"c":1,
            \"cpp":1,
            \}

