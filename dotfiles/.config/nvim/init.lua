-- 基本配置
vim.g.mapleader = ","                           -- leader键默认为\ 设置为,
vim.opt.autowrite = true                        -- 自动保存
vim.opt.shell = "zsh"                           -- 设置默认shell为zsh
vim.opt.updatetime = 300                        -- 过时将交换文件写入磁盘和CursorHold
vim.opt.timeout = true                          -- 修改延迟,详情见 :h timeoutlen
vim.opt.timeoutlen = 1000
vim.opt.ttimeoutlen = 100
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
vim.opt.listchars = "tab:>-,trail:-,extends:>"  -- 设置特殊字符的显示
vim.opt.showmode = false                        -- 不显示INSERT、VISUAL等模式
vim.opt.ignorecase = true                       -- 搜索时忽略大小写

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
        "akinsho/nvim-bufferline.lua",
        dependencies = {
            "nvim-tree/nvim-web-devicons",
        },
        event = "VeryLazy",
        opts = {
            options = {
                indicator = {
                    style = "none",
                },
                offsets = {
                    {
                        filetype = "NvimTree",
                        text = "File Explorer",
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
                lualine_a = {"mode"},
                lualine_b = {"filename"},
                lualine_c = {"diagnostics"},
                lualine_x = {"encoding", "filetype"},
                lualine_y = {"progress"},
                lualine_z = {"location"},
            },
            extensions = { "fzf", "lazy", "nvim-tree" },
        },
    },
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        event = { "BufReadPre", "BufNewFile" },
        config = function()
            require("nvim-treesitter.configs").setup({
                ensure_installed = { "cpp", "lua" },
                highlight = { enable = true },
                indent = { enable = true },
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
        "nvim-tree/nvim-tree.lua",
        dependencies = {
            "nvim-tree/nvim-web-devicons",
        },
        init = function()
            vim.g.loaded_netrw = 1
            vim.g.loaded_netrwPlugin = 1
        end,
        keys = {
            {"<leader>e", "<cmd>NvimTreeToggle<CR>"},
        },
        opts = {
        },
    },
    {
        "tpope/vim-commentary",
        init = function()
            vim.cmd([[autocmd FileType c,cpp setlocal commentstring=//\ %s]])
        end,
        keys = {
            {"<leader><leader>", "<Plug>CommentaryLine"},
            {"<leader><leader>", "<Plug>Commentary", mode = {"v"} },
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
            {"<leader>ff", "<cmd>Files<CR>"},
            {"<leader>fg", "<cmd>GFiles<CR>"},
            {"<leader>fw", "<cmd>Rg<CR>"},
            {"<leader>fb", "<cmd>Buffers<CR>"},
        },
    },
    {
        "neoclide/coc.nvim",
        branch = "release",
        init = function()
            vim.g.coc_global_extensions = {
                "coc-json",
                "coc-clangd",
            }
        end,
        config = function()
            vim.keymap.set("i", "<TAB>", 'coc#pum#visible() ? coc#pum#confirm() : "<TAB>"', {silent = true, expr = true})
            vim.keymap.set("i", "<CR>", 'coc#pum#visible() ? coc#pum#confirm() : "<CR>"', {silent = true, expr = true})
            vim.keymap.set("i", "<C-space>", "coc#refresh()", {silent = true, expr = true})
            vim.keymap.set("n", "K", function()
                local cw = vim.fn.expand('<cword>')
                if vim.fn.index({'vim', 'help'}, vim.bo.filetype) >= 0 then
                    vim.api.nvim_command('h ' .. cw)
                elseif vim.api.nvim_eval('coc#rpc#ready()') then
                    vim.fn.CocActionAsync('doHover')
                else
                    vim.api.nvim_command('!' .. vim.o.keywordprg .. ' ' .. cw)
                end
            end , {silent = true})
            vim.keymap.set("n", "gd", "<Plug>(coc-definition)", {silent = true})
            vim.keymap.set("n", "gr", "<Plug>(coc-references)", {silent = true})
            vim.keymap.set("n", "<leader>rn", "<Plug>(coc-rename)", {silent = true})
            vim.keymap.set("n", "<leader>qf", "<Plug>(coc-fix-current)", {silent = true})
            vim.keymap.set("n", "<leader>sw", ":CocCommand clangd.switchSourceHeader<CR>", {silent = true})
            vim.keymap.set("n", "<leader>fo", ":CocCommand editor.action.formatDocument<CR>", {silent = true})
        end,
    },
    {
        "github/copilot.vim",
        init = function()
            vim.g.copilot_no_tab_map = true
        end,
        event = "InsertEnter",
        config = function()
            vim.cmd([[imap <silent><script><expr> <C-F> copilot#Accept("\<CR>")]])
        end,
    }
})
