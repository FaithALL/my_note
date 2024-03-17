-- neovim quickfix enhance
-- MacPath: ${HOME}/.config/nvim/lua/core/quickfix.lua
-- LinuxPath: ${HOME}/.config/nvim/lua/core/quickfix.lua

local quickfix_preview_winid = nil

local function quickfix_update_preview(qf_item)
    local current_filetype = vim.api.nvim_buf_get_option(qf_item.bufnr, "filetype")
    if current_filetype == "" then
        vim.api.nvim_buf_call(qf_item.bufnr, function()
            vim.cmd("filetype detect")
        end)
    end
    if not quickfix_preview_winid then
        quickfix_preview_winid = vim.api.nvim_open_win(qf_item.bufnr, false, {
            relative = "win",
            win = 0,
            anchor = "SW",
            row = -1,
            col = 0,
            width = vim.api.nvim_win_get_width(0),
            height = vim.api.nvim_win_get_height(0),
            focusable = false,
            border= "rounded",
        })
    end
    vim.api.nvim_win_set_buf(quickfix_preview_winid, qf_item.bufnr)
    vim.api.nvim_win_set_cursor(quickfix_preview_winid, { qf_item.lnum, 0 })
end

local function quickfix_close_preview()
    if quickfix_preview_winid then
        vim.api.nvim_win_close(quickfix_preview_winid, true)
        quickfix_preview_winid = nil
    end
end

local quickfix_enhance_augroup = vim.api.nvim_create_augroup("QuickfixEnhance", { clear = true })
vim.api.nvim_create_autocmd({ "FileType" }, {
    pattern = "qf",
    group = quickfix_enhance_augroup,
    callback = function(args)
        vim.api.nvim_create_autocmd({ "CursorMoved" }, {
            buffer = args.buf,
            group = quickfix_enhance_augroup,
            callback = function()
                local lnum = vim.api.nvim_win_get_cursor(0)[1]
                local qf_item = vim.fn.getqflist()[lnum]
                quickfix_update_preview(qf_item)
            end,
        })

        vim.api.nvim_create_autocmd({ "WinLeave" }, {
            buffer = args.buf,
            group = quickfix_enhance_augroup,
            callback = quickfix_close_preview,
        })

        vim.keymap.set("n", "<CR>", function()
            quickfix_close_preview()
            return "<CR>"
        end, { buffer = args.buf, expr = true })

        vim.keymap.set("n", "<Esc>", quickfix_close_preview, { buffer = args.buf })
    end
})
