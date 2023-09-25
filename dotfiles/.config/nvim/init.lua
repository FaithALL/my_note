-- 基本配置
vim.g.mapleader = ","                           -- leader键默认为\ 设置为,
vim.opt.autowrite = true                        -- 自动保存
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
vim.cmd([[autocmd TermOpen * startinsert]])     -- 打开终端时自动进入插入模式

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
        "nvim-neo-tree/neo-tree.nvim",
        branch = "v3.x",
        dependencies = {
          "nvim-lua/plenary.nvim",
          "nvim-tree/nvim-web-devicons",
          "MunifTanjim/nui.nvim",
        },
        keys = {
          { "<leader>e", "<cmd>Neotree toggle<cr>"},
        },
        opts = {
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
                lualine_a = {"mode"},
                lualine_b = {"filename"},
                lualine_c = {"diagnostics"},
                lualine_x = {
                    function()
                        return vim.fn["codeium#GetStatusString"]()
                    end,
                    "encoding",
                    "filetype",
                },
                lualine_y = {"progress"},
                lualine_z = {
                  function()
                    return " " .. os.date("%R")
                  end,
                },
            },
            extensions = { "fzf", "lazy", "neo-tree" },
        },
    },
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        event = { "BufReadPre", "BufNewFile" },
        config = function()
            require("nvim-treesitter.configs").setup({
                ensure_installed = { "cpp", "kotlin", "lua", "python" },
                highlight = { enable = true },
            })
        end,
    },
    {
        "RRethy/vim-illuminate",
        event = { "BufReadPost", "BufNewFile" },
        opts = {
            delay = 200,
        },
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
            {"<leader>fw", "<cmd>Rg<CR>"},
            {"<leader>fb", "<cmd>Buffers<CR>"},
            {"<leader>fhf", "<cmd>History<CR>"},
            {"<leader>fh/", "<cmd>History/<CR>"},
            {"<leader>fh:", "<cmd>History:<CR>"},
        },
    },
    {
        "neoclide/coc.nvim",
        branch = "release",
        dependencies = {
            "rcarriga/nvim-notify",
        },
        init = function()
            vim.g.coc_global_extensions = {
                "coc-pairs",
                "coc-json",
                "coc-clangd",
                "coc-pyright",
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
            vim.keymap.set("n", "<leader>sw", "<cmd>CocCommand clangd.switchSourceHeader<CR>", {silent = true})
            vim.keymap.set("n", "<leader>fo", "<cmd>CocCommand editor.action.formatDocument<CR>", {silent = true})

            local coc_status_record = {}

            require("notify").setup({
                timeout = 1000,
                minimum_width = 30,
            })

            function reset_coc_status_record(window)
              coc_status_record = {}
            end

            function coc_status_notify(msg, level)
              local notify_opts = { title = "LSP Status", timeout = 500, hide_from_history = true, on_close = reset_coc_status_record }
              if coc_status_record ~= {} then
                notify_opts["replace"] = coc_status_record.id
              end
              coc_status_record = require("notify")(msg, level, notify_opts)
            end

            vim.cmd[[
                function! s:StatusNotify() abort
                  let l:status = get(g:, 'coc_status', '')
                  let l:level = 'info'
                  if empty(l:status) | return '' | endif
                  call v:lua.coc_status_notify(l:status, l:level)
                endfunction

                autocmd User CocStatusChange call s:StatusNotify()
            ]]
        end,
    },
    {
        "Exafunction/codeium.vim",
        init = function()
            vim.g.codeium_no_map_tab = true
        end,
        event = "InsertEnter",
        config = function()
            vim.cmd([[imap <silent><script><nowait><expr> <C-F> codeium#Accept()]])
        end,
    },
})
