-- neovim 自动补全
-- MacPath: ${HOME}/.config/nvim/lua/plugins/complete.lua
-- LinuxPath: ${HOME}/.config/nvim/lua/plugins/complete.lua

return {
    {
        "hrsh7th/nvim-cmp",
        event = "InsertEnter",
        dependencies = {
            "hrsh7th/cmp-path",
            "hrsh7th/cmp-buffer",
            "hrsh7th/cmp-nvim-lsp",
            "L3MON4D3/LuaSnip",
            "saadparwaiz1/cmp_luasnip",
        },
        opts = function()
            local cmp = require("cmp")
            local luasnip = require("luasnip")
            return {
                completion = {
                    completeopt = "menu,menuone,noinsert",
                },
                snippet = {
                    expand = function(args)
                        luasnip.lsp_expand(args.body)
                    end,
                },
                mapping = cmp.mapping.preset.insert({
                    ["<C-n>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
                    ["<C-p>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
                    ["<C-d>"] = cmp.mapping.scroll_docs(6),
                    ["<C-u>"] = cmp.mapping.scroll_docs(-6),
                    ["<C-Space>"] = cmp.mapping.complete(),
                    ["<CR>"] = cmp.mapping.confirm({ select = true }),
                    ["<Tab>"] = cmp.mapping.confirm({ select = true }),
                    ["<C-j>"] = cmp.mapping(function(fallback)
                        if luasnip.jumpable(1) then
                            luasnip.jump(1)
                        else
                            fallback()
                        end
                    end, { "i", "s" }),
                    ["<C-k>"] = cmp.mapping(function(fallback)
                        if luasnip.jumpable(-1) then
                            luasnip.jump(-1)
                        else
                            fallback()
                        end
                    end, { "i", "s" }),
                }),
                sources = cmp.config.sources({
                    { name = "nvim_lsp" },
                    { name = "path" },
                    { name = "luasnip" },
                }, {
                    { name = "buffer" },
                }),
                performance = {
                    max_view_entries = 50,
                },
                formatting = {
                    format = function(_, item)
                        local kind_icons = {
                          Text = "󰉿",
                          Method = "󰆧",
                          Function = "󰊕",
                          Constructor = "",
                          Field = "󰜢",
                          Variable = "󰀫",
                          Class = "󰠱",
                          Interface = "",
                          Module = "",
                          Property = "󰜢",
                          Unit = "",
                          Value = "󰎠",
                          Enum = "",
                          Keyword = "󰌋",
                          Snippet = "",
                          Color = "󰏘",
                          File = "󰈙",
                          Reference = "",
                          Folder = "󰉋",
                          EnumMember = "",
                          Constant = "󰏿",
                          Struct = "󰙅",
                          Event = "",
                          Operator = "󰆕",
                          TypeParameter = "󰅲",
                        }

                        if kind_icons[item.kind] then
                            item.kind = string.format("%s %s", kind_icons[item.kind], item.kind)
                        end
                        return item
                    end,
                },
            }
        end,
    },
}
