local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

local opts = {}

require("vim-options")
require("lazy").setup("plugins")


-- try loading local settings
local function try_load_settings()
    local cwd = vim.fn.getcwd()
    local settings_file = cwd .. "/settings.lua"
    if vim.fn.filereadable(settings_file) ~= 0 then
        local ok, err = pcall(dofile, settings_file)
        if not ok then
            print("Failed to load settings: " .. err)
        end
    end
end

try_load_settings()


local augroup = vim.api.nvim_create_augroup
local ThePrimeagenGroup = augroup('ThePrimeagen', {})

local autocmd = vim.api.nvim_create_autocmd
local yank_group = augroup('HighlightYank', {})


autocmd('TextYankPost', {
    group = yank_group,
    pattern = '*',
    callback = function()
        vim.highlight.on_yank({
            higroup = 'IncSearch',
            timeout = 40,
        })
    end,
})

autocmd({"BufWritePre"}, {
    group = ThePrimeagenGroup,
    pattern = "*",
    command = "%s/\\s\\+$//e",
})

vim.g.netrw_browse_split = 0
-- vim.g.netrw_banner = 0
-- vim.g.netrw_winsize = 25


-- write on insert leave
autocmd("InsertLeave", {
    pattern = "*",
    command = "silent! write",
})

-- Write on text change in normal mode
autocmd("TextChanged", {
    pattern = "*",
    command = "silent! write",
})


-- write on terminal leave to save all buffers when we exit lazygit
-- autocmd("TermLeave", {
--     pattern = "*",
--     command = "bufdo checktime",
-- })
