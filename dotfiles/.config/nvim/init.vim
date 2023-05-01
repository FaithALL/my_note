" ===========基本==============
set noswapfile                                      " 不使用交换文件
set wildmenu                                        " 开启vim命令模式智能补全
set mouse=a                                         " 所有模式可以使用鼠标
set updatetime=300                                  " 过时将交换文件写入磁盘和CursorHold
set timeout timeoutlen=1000 ttimeoutlen=100         " 修改延迟,详情见 :h timeoutlen
let mapleader=","                                   " leader键默认为\ 设置为,

" ==========缩进相关===========
filetype indent on                                  " 开启文件类型检查并适应不同语言缩进
set autoindent                                      " 嵌入新一行使用同样缩进
set expandtab                                       " 将新插入的Tab替换成空格
set tabstop=4                                       " 一个Tab显示的空格数,也用于expandtab
set shiftwidth=4                                    " 缩进的宽度, 用于>>, <<等
set softtabstop=4                                   " 影响backspace的行为

" ===========显示==============
syntax enable                                       " 开启语法高亮
set number                                          " 当前行显示绝对行号
set relativenumber                                  " 其他行显示相对行号
set cursorline                                      " 高亮当前行
set laststatus=2                                    " 总是显示statusline
set signcolumn=yes                                  " 总是显示signcolumn
set guicursor=""                                    " 进入nvim不改变终端光标
set fillchars=vert:│                                " vim设置分屏分割符为│
set noshowmode                                      " 不显示INSERT、VISUAL等模式
set showcmd                                         " 显示部分命令的状态
set showmatch                                       " 高亮括号另一半
set incsearch                                       " 开启实时搜索,跳到第一个匹配项
set ignorecase                                      " 搜索时忽略大小写
set hlsearch                                        " 搜索时高亮显示匹配项
set foldmethod=syntax                               " 基于语法进行代码折叠
set nofoldenable                                    " 启动vim时关闭代码折叠
set background=dark                                 " 暗色背景
nnoremap <silent> <C-L> :nohlsearch<return><C-L>    " <C-L>取消搜索结果的高亮

" ======================vim-plug插件=========================
call plug#begin()
    Plug 'sainnhe/gruvbox-material'                                     " 颜色主题
    Plug 'itchyny/lightline.vim'                                        " statusline
    Plug 'junegunn/fzf'                                                 " 模糊搜索
    Plug 'junegunn/fzf.vim'                                             " 模糊搜索
    Plug 'neoclide/coc.nvim', {'branch': 'release'}                     " coc
    Plug 'bfrg/vim-cpp-modern'                                          " cpp语法高亮
call plug#end()

" ==========================颜色主题=========================
" 在MacOS上,terminfo的xterm-256color存在问题,斜体注释不可用
" https://apple.stackexchange.com/questions/266333/how-to-show-italic-in-vim-in-iterm2
colorscheme gruvbox-material

" =========================statusline========================
let g:lightline = { 'colorscheme': 'gruvbox_material' }

" ==========================模糊搜索=========================
" 默认不预览, 使用ctrl-/切换预览
let g:fzf_preview_window = ['hidden,right,50%', 'ctrl-/']
nnoremap <leader>ff :Files<CR>
nnoremap <leader>fg :GFiles<CR>
nnoremap <leader>fw :Rg<CR>
nnoremap <leader>fb :Buffers<CR>

" =========================== COC ===========================
" coc扩展, 部分插件配置文件见 :CocConfig
let g:coc_config_home = '~/.config/nvim'
let g:coc_global_extensions = ['coc-pairs', 'coc-json', 'coc-clangd']
inoremap <silent><expr> <TAB> coc#pum#visible() ? coc#pum#confirm() : "<TAB>"
inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm() : "<CR>"
if has('nvim')
  inoremap <silent><expr> <C-space> coc#refresh()
else
  inoremap <silent><expr> <C-@> coc#refresh()
endif

nnoremap <silent> K :call ShowDocumentation()<CR>
function! ShowDocumentation()
  if CocAction('hasProvider', 'hover')
    call CocActionAsync('doHover')
  else
    call feedkeys('K', 'in')
  endif
endfunction

nnoremap <silent> [g <Plug>(coc-diagnostic-prev)
nnoremap <silent> g] <Plug>(coc-diagnostic-next)
nnoremap <silent> gd <Plug>(coc-definition)
nnoremap <silent> gtd <Plug>(coc-type-definition)
nnoremap <silent> gi <Plug>(coc-implementation)
nnoremap <silent> gr <Plug>(coc-references)
nnoremap <leader>rn <Plug>(coc-rename)
nnoremap <leader>re <Plug>(coc-refactor)
nnoremap <leader>qf <Plug>(coc-fix-current)
nnoremap <leader>ch :CocCommand clangd.switchSourceHeader<CR>
