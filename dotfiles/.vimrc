" ===========基本==============
set noswapfile                                      " 不使用交换文件
set wildmenu                                        " 开启命令模式智能补全
set mouse=a                                         " 所有模式可以使用鼠标
if $TERM == 'alacritty'                             " alacritty终端设置鼠标识别方式
    set ttymouse=sgr
endif
set shell=zsh                                       " 设置默认shell为zsh
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
set fillchars=vert:│                                " 分屏分割符为│
set list                                            " 默认显示特殊字符
set listchars=tab:>-                                " \t显示为>-
set noshowmode                                      " 不显示INSERT、VISUAL等模式
set showcmd                                         " 显示部分命令的状态
set showmatch                                       " 高亮括号另一半
set incsearch                                       " 开启实时搜索,跳到第一个匹配项
set ignorecase                                      " 搜索时忽略大小写
set hlsearch                                        " 搜索时高亮显示匹配项
set foldmethod=syntax                               " 基于语法进行代码折叠
set nofoldenable                                    " 启动时关闭代码折叠
set background=dark                                 " 暗色背景
nnoremap <silent> <C-L> :nohlsearch<return><C-L>

" ======================vim-plug插件=========================
call plug#begin()
    Plug 'sainnhe/gruvbox-material'                                     " 颜色主题
    Plug 'luochen1990/rainbow'                                          " 彩虹括号
    Plug 'itchyny/lightline.vim'                                        " statusline
    Plug 'junegunn/fzf'                                                 " 模糊搜索
    Plug 'junegunn/fzf.vim'                                             " 模糊搜索
    Plug 'tpope/vim-fugitive'                                           " git命令
    Plug 'neoclide/coc.nvim', {'branch': 'release'}                     " coc
    Plug 'bfrg/vim-cpp-modern'                                          " cpp语法高亮
    Plug 'udalov/kotlin-vim'                                            " kotlin语法高亮
    Plug 'tikhomirov/vim-glsl'                                          " glsl语法高亮
call plug#end()

" ==========================颜色主题=========================
" 在MacOS上,terminfo的xterm-256color存在问题,斜体注释不可用
" https://apple.stackexchange.com/questions/266333/how-to-show-italic-in-vim-in-iterm2
colorscheme gruvbox-material

" ==========================彩虹括号=========================
let g:rainbow_active = 1
let g:rainbow_conf = {
    \ 'ctermfgs': [ 'red', 'lightgreen', 'yellow', 'lightblue', 'magenta', 'lightcyan' ]
    \ }

" =========================statusline========================
function! CocCurrentFunction()
    return get(b:, 'coc_current_function', '')
endfunction

function! GitBranch()
    let branch = FugitiveHead()
    return branch !=# '' ? ' ' . branch : ''
endfunction

let g:lightline = {
    \ 'colorscheme': 'gruvbox_material',
    \ 'active': {
    \     'left': [ [ 'mode', 'paste' ],
    \               [ 'filename', 'modified', 'currentfunction' ] ],
    \     'right': [ [ 'lineinfo' ],
    \                [ 'percent' ],
    \                [ 'gitbranch', 'fileencoding', 'filetype'] ],
    \ },
    \ 'component_function': {
    \     'currentfunction': 'CocCurrentFunction',
    \     'gitbranch': 'GitBranch',
    \ },
    \ }

" ==========================模糊搜索=========================
" 默认不预览, 使用ctrl-/切换预览
let g:fzf_preview_window = ['hidden,right,50%', 'ctrl-/']
nnoremap <silent> <leader>ff :Files<CR>
nnoremap <silent> <leader>fg :GFiles<CR>
nnoremap <silent> <leader>fw :Rg<CR>
nnoremap <silent> <leader>fb :Buffers<CR>

" =========================== COC ===========================
" coc扩展, 部分插件配置文件见 :CocConfig
let g:coc_config_home = '~/.config/coc'
let g:coc_global_extensions = ['coc-pairs', 'coc-explorer', 'coc-json', 'coc-clangd']
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
nnoremap <silent> <leader>rn <Plug>(coc-rename)
nnoremap <silent> <leader>re <Plug>(coc-refactor)
nnoremap <silent> <leader>qf <Plug>(coc-fix-current)
nnoremap <silent> <leader>ch :CocCommand clangd.switchSourceHeader<CR>
nnoremap <silent> <leader>e :CocCommand explorer --sources=buffer+,file+<CR>
nnoremap <silent> <leader>j :call CocAction('runCommand', 'explorer.doAction', 'closest', ['reveal:0'], [['relative', 0, 'file']])<CR>
