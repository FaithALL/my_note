
set encoding=utf-8	"设置编码
set number "设置行号

set shiftwidth=4	"默认缩进4个空格
set softtabstop=4	"使用tab时tab空格数
set autoindent		"自动缩进

call plug#begin('~/.vim/plugged')	"vim-plug插件管理器
Plug 'valloric/youcompleteme',{'for':['c','cpp']}
Plug 'octol/vim-cpp-enhanced-highlight',{'for':['c','cpp']}
call plug#end()
let g:ycm_global_ycm_extra_conf='~/.vim/plugged/youcompleteme/third_party/ycmd/.ycm_extra_conf.py'

"两个字母就触发语义补全
let g:ycm_semantic_triggers =  {
			\ 'c,cpp': ['re!\w{2}'],
			\ }

"候选补全区的颜色
highlight PMenu ctermfg=0 ctermbg=242 guifg=black guibg=darkgrey
highlight PMenuSel ctermfg=242 ctermbg=8 guifg=darkgrey guibg=black

"关闭函数原型预览
set completeopt=menu,menuone
let g:ycm_add_preview_to_completeopt = 0
