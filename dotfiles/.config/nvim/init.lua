-- neovim 配置
-- MacPath: ${HOME}/.config/nvim/init.lua
-- LinuxPath: ${HOME}/.config/nvim/init.lua

require("core.base")
require("core.git")
require("core.quickfix")

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

require("lazy").setup("plugins")
