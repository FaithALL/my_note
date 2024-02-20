-- neovim 配置
-- MacPath: ${HOME}/.config/nvim/init.lua
-- LinuxPath: ${HOME}/.config/nvim/init.lua

-- 基本配置
vim.g.mapleader = ","                           -- leader键默认为\ 设置为,
vim.opt.shell = "zsh"                           -- 设置默认shell为zsh
vim.opt.undofile = true                         -- 再次进入buffer仍可undo/redo
vim.opt.updatetime = 300                        -- 过时将交换文件写入磁盘和CursorHold
vim.opt.timeout = true                          -- 修改延迟,详情见 :h timeoutlen
vim.opt.timeoutlen = 1000
vim.opt.ttimeoutlen = 100
vim.opt.clipboard = "unnamedplus"               -- 共享系统剪贴板
vim.cmd("filetype indent on")                   -- 开启文件类型检查并适应不同语言缩进
vim.opt.autoindent = true                       -- 新一行使用同样缩进
vim.opt.expandtab = true                        -- 将新插入的Tab替换成空格
vim.opt.tabstop = 4                             -- 一个Tab显示的空格数,也用于expandtab
vim.opt.shiftwidth = 4                          -- 缩进的宽度, 用于>>, <<等
vim.opt.softtabstop = 4                         -- 影响backspace的行为
vim.cmd("syntax enable")                        -- 开启语法高亮
vim.opt.termguicolors = true                    -- 开启24位色(需要终端支持)
vim.opt.wrap = false                            -- 不折行
vim.opt.number = true                           -- 显示行号
vim.opt.cursorline = true                       -- 高亮当前行
vim.opt.guicursor = ""                          -- nvim设置光标样式
vim.opt.signcolumn = "yes"                      -- 总是显示signcolumn
vim.opt.list = true                             -- 默认显示特殊字符
vim.opt.shortmess:append("I")                   -- 启动时不显示intro
vim.opt.listchars = "tab:>-,trail:-,extends:>"  -- 设置特殊字符的显示
vim.opt.showmode = false                        -- 不显示INSERT、VISUAL等模式
vim.opt.ignorecase = true                       -- 搜索时忽略大小写
-- buffer keymap
-- vim.keymap.set("n", "<leader>bd", "<Cmd>bprevious | bdelete#<CR>", { silent = true, desc = "Buffer delete" })

-- 插件管理器
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable",
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

-- 插件声明
require("lazy").setup("plugins")
