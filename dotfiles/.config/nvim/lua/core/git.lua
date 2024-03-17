-- neovim git
-- MacPath: ${HOME}/.config/nvim/lua/core/git.lua
-- LinuxPath: ${HOME}/.config/nvim/lua/core/git.lua

local function git_function(bufnr, get_command, on_stdout)
    if vim.api.nvim_buf_get_option(bufnr, "buftype") ~= "" then
        return
    end
    local filename = vim.api.nvim_buf_get_name(bufnr)
    local cwd = filename:match("(.*)/")
    local command = string.format("git ls-files --error-unmatch %s >/dev/null 2>&1 && %s", filename, get_command(filename))
    local job_id = vim.fn.jobstart(command, {
        cwd = cwd,
        on_stdout = function(chan_id, data, name)
            on_stdout(data)
        end,
        stdout_buffered = true,
    })

    local buffer_content = table.concat(vim.api.nvim_buf_get_lines(bufnr, 0, -1, false), "\n") .. "\n"
    vim.fn.chansend(job_id, buffer_content)
    vim.fn.chanclose(job_id, "stdin")
end

local function git_blame(bufnr, lnum, ns_id)
    local git_command = function(filename)
        return string.format("git blame --contents - \"%s\" --porcelain -L %d,%d -M", filename, lnum, lnum)
    end

    git_function(bufnr, git_command, function(data)
        if #data == 1 and data[1] == "" then
            return
        end
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

        local function format_blame_info(info)
            if info.author == "Not Committed Yet" then
                return "Not Committed Yet"
            end
            return string.format(" %s, %s - %s",
                info.author,
                os.date("%Y-%m-%d", info.commit_time),
                info.summary)
        end

        vim.api.nvim_buf_set_extmark(bufnr, ns_id, lnum-1, 0, {
            virt_text = {{ format_blame_info(result), "Comment" }},
            virt_text_pos = "eol",
            hl_mode = "combine",
        })
    end)
end

local function clear_blames(ns_id)
    for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
        vim.api.nvim_buf_clear_namespace(bufnr, ns_id, 0, -1)
    end
end

local blame_is_active = false
local blame_ns_id = vim.api.nvim_create_namespace("GitBlameNamespace")
local blame_augroup = vim.api.nvim_create_augroup("GitBlame", { clear = true })
function toggle_blame()
    blame_is_active = not blame_is_active
    if blame_is_active then
        local blame_last_lnum = -1
        vim.api.nvim_create_autocmd({ "CursorHold" }, {
            group = blame_augroup,
            callback = function(args)
                local lnum = vim.api.nvim_win_get_cursor(0)[1]
                if blame_last_lnum ~= lnum then
                    clear_blames(blame_ns_id)
                    git_blame(args.buf, lnum, blame_ns_id)
                    blame_last_lnum = lnum
                end
            end
        })

        vim.api.nvim_create_autocmd({ "InsertEnter" }, {
            group = blame_augroup,
            callback = function()
                clear_blames(blame_ns_id)
                blame_last_lnum = -1
            end,
        })
    else
        clear_blames(blame_ns_id)
        vim.api.nvim_clear_autocmds({ group = blame_augroup })
    end
end

local function git_diff(bufnr)
    local function git_command(filename)
        local basename = filename:match("([^\\/]+)$")
        return string.format("diff -U0 <(git show HEAD:./%s) -", basename)
    end

    git_function(bufnr, git_command, function(data)
        local sign_group = "GitDiffSign"
        vim.fn.sign_unplace(sign_group, { buffer = bufnr })

        local sign_list = {}
        for _, line in ipairs(data) do
            local pattern = "^@@ %-([%d]+),?([%d]*) %+([%d]+),?([%d]*) @@"
            local start1, count1, start2, count2 = line:match(pattern)
            if start1 and start2 then
                count1 = tonumber(count1) or 1
                start2 = tonumber(start2)
                count2 = tonumber(count2) or 1

                local sign_name = "GitSignsChange"
                local count = math.max(count2, 1)
                if count1 == 0 then
                    sign_name = "GitSignsAdd"
                elseif count2 == 0 then
                    sign_name = "GitSignsDelete"
                end

                for lnum = start2, start2 + count - 1 do
                    table.insert(sign_list, {
                        buffer = bufnr,
                        group = sign_group,
                        lnum = lnum,
                        name = sign_name,
                    })
                end
            end
        end
        vim.fn.sign_placelist(sign_list)
    end)
end

vim.api.nvim_create_user_command("ToggleBlame", toggle_blame, {})

local signs = { Add = "│", Change = "│", Delete = "_" }
for type, icon in pairs(signs) do
    local name = "GitSigns" .. type
    vim.fn.sign_define(name, { text = icon, texthl = name })
end
vim.api.nvim_create_autocmd( { "BufReadPost", "TextChanged", "TextChangedI" }, {
    group = vim.api.nvim_create_augroup("GitDiff", { clear = true }),
    callback = function(args)
        git_diff(args.buf)
    end,
})
