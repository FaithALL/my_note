-- neovim 配置
-- MacPath: ${HOME}/.config/nvim/lua/plugins/basic.lua
-- LinuxPath: ${HOME}/.config/nvim/lua/plugins/basic.lua

return {
    {
        "sainnhe/gruvbox-material",
        lazy = false,
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
            vim.g.fzf_preview_window = { "hidden,right,50%", "alt-/" }
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
            vim.cmd([[autocmd FileType c,cpp,dart,kotlin setlocal commentstring=//\ %s]])
        end,
        keys = {
            { "<leader><leader>", "<Plug>CommentaryLine", desc = "Comment" },
            { "<leader><leader>", "<Plug>Commentary", mode = { "v" }, desc = "Comment" },
        },
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
            sources = { "filesystem", "git_status", "document_symbols" },
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
                indicator = {
                    style = "none",
                },
                custom_filter = function(buf, _)
                    if vim.bo[buf].filetype == "qf" then
                        return false
                    end
                    return true
                end,
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
                    sections = {
                        lualine_a = { "mode" },
                    },
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
                ensure_installed = { "comment", "cpp", "dart", "kotlin", "lua", "markdown", "python" },
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
        "folke/flash.nvim",
        event = "VeryLazy",
        opts = {},
    },
}
