" vim 配置
" MacPath: ${HOME}/.vimrc
" LinuxPath: ${HOME}/.vimrc
" ===========基本==============
let mapleader=","                                   " leader键默认为\ 设置为,
set autowrite                                       " 自动保存
set shell=zsh                                       " 设置默认shell为zsh
set updatetime=300                                  " 过时将交换文件写入磁盘和CursorHold
set timeout timeoutlen=1000 ttimeoutlen=100         " 修改延迟,详情见 :h timeoutlen

" ==========缩进相关===========
filetype indent on                                  " 开启文件类型检查并适应不同语言缩进
set autoindent                                      " 嵌入新一行使用同样缩进
set expandtab                                       " 将新插入的Tab替换成空格
set tabstop=4                                       " 一个Tab显示的空格数,也用于expandtab
set shiftwidth=4                                    " 缩进的宽度, 用于>>, <<等
set softtabstop=4                                   " 影响backspace的行为

" ===========显示==============
syntax enable                                       " 开启语法高亮
set termguicolors                                   " 开启24位色
set nowrap                                          " 不折行
set number                                          " 显示行号
set cursorline                                      " 高亮当前行
set guicursor=""                                    " nvim设置光标样式
set signcolumn=yes                                  " 总是显示signcolumn
set list                                            " 默认显示特殊字符
set listchars=tab:>-,trail:-,extends:>              " 设置特殊字符的显示
set noshowmode                                      " 不显示INSERT、VISUAL等模式
set ignorecase                                      " 搜索时忽略大小写

if !has('nvim')
    set noswapfile                                      " 不使用交换文件
    set wildmenu                                        " 显示命令模式补全列表
    set wildoptions=pum,tagfile                         " 使用弹出菜单显示补全列表
    set mouse=nvi                                       " 设置可使用鼠标的模式
    set fillchars=vert:│                                " 分屏分割符为│
    set laststatus=2                                    " 总是显示statusline
    set background=dark                                 " 暗色背景
    set showcmd                                         " 显示部分命令的状态
    set incsearch                                       " 开启实时搜索,跳到第一个匹配项
    set hlsearch                                        " 搜索时高亮显示匹配项
    nnoremap <silent> <C-L> :nohlsearch<return><C-L>

    if $TERM == 'alacritty'                             " vim-alacritty设置鼠标识别方式
        set ttymouse=sgr
    endif

    colorscheme morning                                 " 设置默认主题
endif

" ===========插件==============
" 自动下载vim-plug
let data_dir = has('nvim') ? stdpath('data') . '/site' : '~/.vim'
if empty(glob(data_dir . '/autoload/plug.vim'))
  silent execute '!curl -fLo '.data_dir.'/autoload/plug.vim --create-dirs  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin()
    Plug 'sainnhe/gruvbox-material'
    Plug 'voldikss/vim-floaterm'
    Plug 'junegunn/fzf'
    Plug 'junegunn/fzf.vim'
    Plug 'tpope/vim-commentary'
    Plug 'neoclide/coc.nvim', {'branch': 'release'}
call plug#end()

" gruvbox-material
set background=dark
colorscheme gruvbox-material

" vim-floaterm
let g:floaterm_title = ''
let g:floaterm_autoclose = 2
nnoremap    <silent><c-t>   :FloatermToggle<CR>
tnoremap    <silent><c-t>   <c-\><c-n>:FloatermToggle<CR>

" fzf
let g:fzf_preview_window = ['hidden,right,50%', 'ctrl-/']
nnoremap <silent><leader>ff     :Files<CR>
nnoremap <silent><leader>fw     :Rg<CR>
nnoremap <silent><leader>fb     :Buffers<CR>
nnoremap <silent><leader>fhf    :History<CR>
nnoremap <silent><leader>fh/    :History/<CR>
nnoremap <silent><leader>fh:    :History:<CR>

" vim-commentary
autocmd FileType c,cpp,dart,kotlin setlocal commentstring=//\ %s
nnoremap <silent><leader><leader>   <Plug>CommentaryLine"
nnoremap <silent><leader><leader>   <Plug>Commentary"

" coc
let g:coc_global_extensions = ['coc-cmake', 'coc-flutter', 'coc-pairs', 'coc-json', 'coc-clangd', 'coc-pyright']
inoremap <silent><expr><tab>    coc#pum#visible() ? coc#pum#confirm() : '<tab>'
inoremap <silent><expr><CR>     coc#pum#visible() ? coc#pum#confirm() : '<CR>'
inoremap <silent><expr><c-@>    coc#refresh()
nnoremap <silent>gd             <Plug>(coc-definition)
nnoremap <silent>gr             <Plug>(coc-references)
nnoremap <silent><leader>rn     <Plug>(coc-rename)
nnoremap <silent><leader>qf     <Plug>(coc-fix-current)
nnoremap <silent><leader>sw     :CocCommand clangd.switchSourceHeader<CR>
nnoremap <silent><leader>fo     :CocCommand editor.action.formatDocument<CR>
nnoremap <silent>K              :call ShowDocumentation()<CR>
function! ShowDocumentation()
  if CocAction('hasProvider', 'hover')
    call CocActionAsync('doHover')
  else
    call feedkeys('K', 'in')
  endif
endfunction
