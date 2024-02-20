-- neovim lsp
-- MacPath: ${HOME}/.config/nvim/lua/plugins/lsp.lua
-- LinuxPath: ${HOME}/.config/nvim/lua/plugins/lsp.lua

return {
    {
        "neovim/nvim-lspconfig",
        config = function()

            vim.diagnostic.config({ virtual_text = false })
            local signs = { Error = "󰅚 ", Warn = "󰀪 ", Hint = "󰌶 ", Info = " " }
            for type, icon in pairs(signs) do
                local hl = "DiagnosticSign" .. type
                vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
            end

            vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(
                vim.lsp.handlers.hover, {
                    max_width = math.floor(vim.api.nvim_win_get_width(0) * 0.5),
                    max_height = math.floor(vim.api.nvim_win_get_height(0) * 0.8),
                    focusable = false,
                }
            )

            vim.api.nvim_create_autocmd('LspAttach', {
                group = vim.api.nvim_create_augroup('UserLspConfig', { clear = true }),
                callback = function(args)
                    local opts = { buffer = args.buf }
                    vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
                    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
                    vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
                    vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)
                    vim.keymap.set({ 'n', 'v' }, '<leader>ca', vim.lsp.buf.code_action, opts)
                    vim.keymap.set({ 'n', 'v' }, '<leader>qf', function()
                        vim.lsp.buf.code_action{ only = { 'quickfix' } }
                    end, opts)
                    vim.keymap.set('n', '<leader>fo', function()
                        vim.lsp.buf.format{ async = true }
                    end, opts)

                    vim.keymap.set('n', '<leader>sw', "<Cmd>ClangdSwitchSourceHeader<CR>", opts)

                    vim.api.nvim_create_autocmd("CursorHold", {
                        buffer = args.buf,
                        callback = function()

                            -- 如果当前buffer有其他浮动窗口, 不再打开诊断浮动窗口
                            for _, winnr in ipairs(vim.api.nvim_list_wins()) do
                                local win_config = vim.api.nvim_win_get_config(winnr)
                                if win_config.relative ~= '' then
                                    return
                                end
                            end

                            local opts = {
                                focusable = false,
                                close_events = { "BufLeave", "CursorMoved", "InsertEnter", "FocusLost" },
                                scope = "line",
                                prefix = "",
                                header = "",
                            }
                            vim.diagnostic.open_float(nil, opts)
                        end
                    })
                end,
            })

            local capabilities = require('cmp_nvim_lsp').default_capabilities()
            local lspconfig = require("lspconfig")
            lspconfig.clangd.setup {
                cmd = {
                    "clangd",
                    "--background-index",
                    "--clang-tidy",
                    "--header-insertion=iwyu",
                    "--completion-style=detailed",
                    "--function-arg-placeholders",
                    "--fallback-style=llvm",
                },
                capabilities = capabilities,
            }
        end,
    },
}
