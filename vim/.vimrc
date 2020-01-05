set nocompatible	"关闭vi兼容模式
set wildmenu		"开启vim自身命令行智能补全
set mouse=a         "可用鼠标

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

set foldmethod=syntax	"基于语法进行代码折叠
set nofoldenable	    "启动vim时关闭代码折叠


set statusline=\ %f%m\ \ %{&fileencoding}%=%l/%L     "设置状态栏(文件名[+]文件编码|当前行/总行数)


map <F5> :wa<CR>:make<CR><CR>:cw<CR>    "F5一键编译


call plug#begin('~/.vim/plugged')			            "vim-plug插件管理
    Plug 'dracula/vim',{'as': 'dracula' }			            "主题
    Plug 'octol/vim-cpp-enhanced-highlight',{'for':['c','cpp']}	"语法高亮
    Plug 'scrooloose/nerdtree',{'on': 'NERDTreeToggle'}	        "目录
    Plug 'valloric/youcompleteme',{'for':['c','cpp']}	        "自动补全
call plug#end()


"主题插件,修改配色方案
set background=dark	    
colorscheme dracula

"语法高亮插件
let g:cpp_class_decl_highlight = 1      "高亮显示声明中的类名
let g:cpp_class_scope_highlight = 1     "高亮显示::之前的类名


"目录插件
map <F3> :NERDTreeToggle<CR>            "通过F3键展开或者关闭目录 
let NERDTreeMinimalUI=1                 "不再显示Press ? for help
let NERDTreeWinSize=20                  "设置NERDTree窗口大小
let NERDTreeMouseMode=2                 "目录节点单击打开，文件节点双击打开
let NERDTreeAutoDeleteBuffer=1          "删除文件时自动删除文件对应buffer
let NERDTreeStatusline="directory    %l/%L"      "设置NERDTree的状态栏
"设置NERDTree忽略的文件
let NERDTreeIgnore=['\.o','\.png','\.jpg',
            \'\.pdf']              
"如果NERDTree是最后一个窗口自动关闭
autocmd bufenter * if (winnr("$") == 1          
            \&& exists("b:NERDTree") 
            \&& b:NERDTree.isTabTree()) | q | endif


"自动补全插件
"默认配置文件
let g:ycm_global_ycm_extra_conf='~/.vim/plugged/youcompleteme/third_party/ycmd/.ycm_extra_conf.py'
"使用自定义.ycm_extra_conf.py时不询问
let g:ycm_confirm_extra_conf=0
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
"let g:ycm_filetype_whitelist={
"            \"c":1,
"            \"cpp":1,
"            \}

