-- neovim git
-- MacPath: ${HOME}/.config/nvim/lua/core/git.lua
-- LinuxPath: ${HOME}/.config/nvim/lua/core/git.lua

local M = {}
local blame_is_active = false
local blame_augroup = nil
local blame_ns_id = nil
local blame_last_line = -1

local function git_blame(bufnr, line_no)
    local filename = vim.api.nvim_buf_get_name(bufnr)
    local cwd = vim.fn.fnamemodify(filename, ":h")
    local blame_command = "git blame --contents - \"" .. filename .. "\" --porcelain -L " .. line_no .. "," .. line_no .. " -M"
    local job_id = vim.fn.jobstart(blame_command, {
        cwd = cwd,
        on_exit = function(_, exit_code)
            if exit_code ~= 0 then
                -- Could not execute blame, might not be a git repository
                return
            end
        end,
        on_stdout = function(_, data)
            local result = {}

            local patterns = {
                ["^author (.*)"] = "author",
                ["^committer%-time (.*)"] = "commit_time",
                ["^summary (.*)"] = "summary"
            }

            for _, line in ipairs(data) do
                for pattern, key in pairs(patterns) do
                    local match = line:match(pattern)
                    if match then
                        result[key] = match
                        break
                    end
                end
            end

            if vim.tbl_isempty(result) then
                -- Could not execute blame, might not be a git repository
                return
            end

            local function format_blame_info(info)
                if info.author == "Not Committed Yet" then
                    return "Not Committed Yet"
                else
                    return string.format(" %s, %s - %s",
                        info.author,
                        os.date("%Y-%m-%d", info.commit_time),
                        info.summary)
                end
            end

            vim.api.nvim_buf_set_extmark(bufnr, blame_ns_id, line_no-1, 0, {
                virt_text = {{ format_blame_info(result), "Comment" }},
                virt_text_pos = "eol",
                hl_mode = "combine",
            })
        end,
        stdout_buffered = true,
    })
    local buffer_content = table.concat(vim.api.nvim_buf_get_lines(bufnr, 0, -1, false), "\n") .. "\n"
    vim.fn.chansend(job_id, buffer_content)
    vim.fn.chanclose(job_id, "stdin")
end

local function clear_blames()
    for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
        vim.api.nvim_buf_clear_namespace(bufnr, blame_ns_id, 0, -1)
    end
    blame_last_line = -1
end

function M.setup()
    blame_augroup = vim.api.nvim_create_augroup("GitBlame", { clear = true })
    blame_ns_id = vim.api.nvim_create_namespace("GitBlameNamespace")
    vim.api.nvim_create_user_command("ToggleBlame", M.toggle_blame, {})
end

function M.toggle_blame()
    blame_is_active = not blame_is_active
    if blame_is_active then
        vim.api.nvim_create_autocmd({ "CursorHold" }, {
            group = blame_augroup,
            callback = function(args)
                local line_no = vim.api.nvim_win_get_cursor(0)[1]
                if blame_last_line ~= line_no then
                    clear_blames()
                    git_blame(args.buf, line_no)
                    blame_last_line = line_no
                end
            end
        })

        vim.api.nvim_create_autocmd({ "InsertEnter" }, {
            group = blame_augroup,
            callback = function(args)
                clear_blames()
            end
        })
    else
        clear_blames()
        vim.api.nvim_clear_autocmds({ group = blame_augroup })
    end
end

M.setup()
