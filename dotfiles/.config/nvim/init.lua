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
vim.keymap.set("n", "<leader>bn", "<Cmd>bnext<CR>", { silent = true, desc = "Buffer next" })
vim.keymap.set("n", "<leader>bp", "<Cmd>bprevious<CR>", { silent = true, desc = "Buffer previous" })
vim.keymap.set("n", "<leader>bd", "<Cmd>bprevious | bdelete#<CR>", { silent = true, desc = "Buffer delete" })

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

-- 插件
require("lazy").setup({
    {
        "sainnhe/gruvbox-material",
        priority = 1000,
        config = function()
            vim.cmd([[colorscheme gruvbox-material]])
        end,
    },
    {
        "voldikss/vim-floaterm",
        init = function()
            vim.g.floaterm_title = ""
            vim.g.floaterm_autoclose = 2
        end,
        keys = {
            { "<c-t>", "<Cmd>FloatermToggle<CR>", mode = { "n", "t" }, desc = "Toggle Floaterm" },
        },
    },
    {
        "junegunn/fzf.vim",
        dependencies = {
            "junegunn/fzf",
        },
        init = function()
            vim.g.fzf_preview_window = { "hidden,right,50%", "ctrl-/" }
        end,
        keys = {
            { "<leader>ff", "<Cmd>Files<CR>", desc = "Find File" },
            { "<leader>fw", "<Cmd>Rg<CR>", desc = "Find Word" },
            { "<leader>fb", "<Cmd>Buffers<CR>", desc = "Find Buffer" },
            { "<leader>fhf", "<Cmd>History<CR>", desc = "Find History File" },
            { "<leader>fh/", "<Cmd>History/<CR>", desc = "Find History Search" },
            { "<leader>fh:", "<Cmd>History:<CR>", desc = "Find History Command" },
        },
    },
    {
        "tpope/vim-commentary",
        init = function()
            vim.cmd([[autocmd FileType c,cpp setlocal commentstring=//\ %s]])
        end,
        keys = {
            { "<leader><leader>", "<Plug>CommentaryLine", desc = "Comment" },
            { "<leader><leader>", "<Plug>Commentary", mode = { "v" }, desc = "Comment" },
        },
    },
    {
        "neoclide/coc.nvim",
        branch = "release",
        init = function()
            vim.g.coc_global_extensions = {
                "coc-cmake",
                "coc-pairs",
                "coc-json",
                "coc-clangd",
                "coc-pyright",
            }
        end,
        config = function()
            vim.keymap.set( "i", "<tab>", "coc#pum#visible() ? coc#pum#confirm() : '<tab>'", { silent = true, expr = true } )
            vim.keymap.set( "i", "<CR>", "coc#pum#visible() ? coc#pum#confirm() : '<CR>'", {silent = true, expr = true} )
            vim.keymap.set( "i", "<c-space>", "coc#refresh()", {silent = true, expr = true} )
            vim.keymap.set("n", "gd", "<Plug>(coc-definition)", { silent = true, desc = "Go to definition" })
            vim.keymap.set("n", "gr", "<Plug>(coc-references)", { silent = true, desc = "Go to references" })
            vim.keymap.set("n", "<leader>rn", "<Plug>(coc-rename)", { silent = true, desc = "Rename" })
            vim.keymap.set("n", "<leader>qf", "<Plug>(coc-fix-current)", { silent = true, desc = "Quickfix" })
            vim.keymap.set("n", "<leader>sw", "<Cmd>CocCommand clangd.switchSourceHeader<CR>", { silent = true, desc = "Switch (c family)" })
            vim.keymap.set("n", "<leader>fo", "<Cmd>CocCommand editor.action.formatDocument<CR>", { silent = true, desc = "Format" })
            vim.keymap.set(
                "n",
                "K",
                function()
                    local cw = vim.fn.expand("<cword>")
                    if vim.fn.index({"vim", "help"}, vim.bo.filetype) >= 0 then
                        vim.api.nvim_command("h " .. cw)
                    elseif vim.api.nvim_eval("coc#rpc#ready()") then
                        vim.fn.CocActionAsync("doHover")
                    else
                        vim.api.nvim_command("!" .. vim.o.keywordprg .. " " .. cw)
                    end
                end,
                {silent = true}
            )
        end,
    },
    {
        "Exafunction/codeium.vim",
        init = function()
            vim.g.codeium_no_map_tab = true
        end,
        event = "InsertEnter",
        config = function()
            vim.cmd([[imap <silent><script><nowait><expr> <c-f> codeium#Accept()]])
        end,
    },
    {
        "nvim-neo-tree/neo-tree.nvim",
        branch = "v3.x",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-tree/nvim-web-devicons",
            "MunifTanjim/nui.nvim",
        },
        keys = {
            { "<leader>e", "<Cmd>Neotree toggle<CR>", desc = "Toggle File Explorer" }
        },
        opts = {
            close_if_last_window = true,
            sources = { "filesystem", "git_status" },
            filesystem = {
                filtered_items = {
                    hide_dotfiles = false,
                },
                follow_current_file = { enabled = true },
            },
        }
    },
    {
        "akinsho/nvim-bufferline.lua",
        dependencies = {
            "nvim-tree/nvim-web-devicons",
        },
        event = "VeryLazy",
        opts = {
            options = {
                always_show_bufferline = false,
                indicator = {
                    style = "none",
                },
                offsets = {
                    {
                        filetype = "neo-tree",
                        text = "File Explorer",
                        highlight = "Directory",
                        text_align = "left",
                        separator = false,
                    },
                },
            },
        },
    },
    {
        "nvim-lualine/lualine.nvim",
        dependencies = {
            "nvim-tree/nvim-web-devicons",
        },
        event = "VeryLazy",
        opts = {
            options = {
                theme = "gruvbox-material",
                section_separators = "",
                component_separators = { left = "|", right = "|" },
                globalstatus = true,
            },
            sections = {
                lualine_a = { "mode" },
                lualine_b = { "filename" },
                lualine_c = { "diagnostics" },
                lualine_x = {
                    function()
                        return vim.fn["codeium#GetStatusString"]()
                    end,
                    "encoding",
                    "filetype",
                },
                lualine_y = { "progress" },
                lualine_z = { "location" },
            },
            extensions = {
                "fzf",
                "lazy",
                "neo-tree",
                {
                    sections = { lualine_a = { "mode" } },
                    filetypes = { "floaterm" },
                },
            },
        }
    },
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        event = { "BufReadPre", "BufNewFile" },
        config = function()
            require("nvim-treesitter.configs").setup({
                ensure_installed = { "comment", "cpp", "kotlin", "lua", "markdown", "python" },
                highlight = { enable = true },
            })
        end,
    },
    {
        "RRethy/vim-illuminate",
        event = { "BufReadPost", "BufNewFile" },
        config = function()
            require("illuminate").configure({
                delay = 200,
            })
        end,
    },
    {
        "lewis6991/gitsigns.nvim",
        event = { "BufReadPre", "BufNewFile" },
        opts = {
            numhl = true,
        },
    },
    {
        "folke/flash.nvim",
        event = "VeryLazy",
        opts = {},
    },
})
