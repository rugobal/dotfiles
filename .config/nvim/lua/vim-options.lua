vim.g.mapleader = "\\"
vim.cmd("set clipboard=unnamedplus")
vim.cmd("set expandtab")
vim.cmd("set tabstop=2")
vim.cmd("set softtabstop=2")
vim.cmd("set shiftwidth=2")
vim.opt.smartindent = true

vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
vim.opt.undofile = true

vim.opt.hlsearch = false
vim.opt.incsearch = true

-- let's try these out
vim.opt.termguicolors = true
vim.opt.scrolloff = 8
vim.opt.signcolumn = "yes"
vim.opt.isfname:append("@-@")
vim.opt.updatetime = 50
--vim.opt.colorcolumn = "80"

vim.opt.timeout = true
vim.opt.timeoutlen = 500 -- Time in milliseconds; adjust to your preference

-- remap C-v to <leader>v for visual block mode
vim.api.nvim_set_keymap("n", "<leader>v", "<C-v>", { noremap = true, silent = true })

-- do not wrap lines
vim.opt.wrap = true -- Enable line wrapping to try
vim.opt.number = true         -- Enable absolute line numbers
vim.opt.relativenumber = true -- Enable relative line numbers

vim.opt.ignorecase = true  -- Makes search case insensitive
vim.opt.smartcase = true   -- Case-sensitive if uppercase letters are used in the searc

-- Increase window height
vim.api.nvim_set_keymap("n", "<C-Up>", ":resize +5<CR>", { noremap = true, silent = true })

-- Decrease window height
vim.api.nvim_set_keymap("n", "<C-Down>", ":resize -5<CR>", { noremap = true, silent = true })

-- Increase window width
vim.api.nvim_set_keymap("n", "<C-Right>", ":vertical resize +5<CR>", { noremap = true, silent = true })

-- Decrease window width
vim.api.nvim_set_keymap("n", "<C-Left>", ":vertical resize -5<CR>", { noremap = true, silent = true })

-- vim.keymap.set('v', 'I', function()
--     -- Exit visual mode and store the selection marks before the prompt
--     vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<Esc>', true, false, true), 'x', true)
--     vim.defer_fn(function()
--         local start_line, end_line = vim.fn.line("'<"), vim.fn.line("'>")
--         local text_to_insert = vim.fn.input("Text to insert: ")
--         if text_to_insert == "" then return end
--
--         -- Apply the text insertion
--         for line = start_line, end_line do
--             local line_content = vim.api.nvim_buf_get_lines(0, line - 1, line, false)[1] or ""
--             vim.api.nvim_buf_set_lines(0, line - 1, line, false, {text_to_insert .. line_content})
--         end
--     end, 0)
-- end, {desc = "Insert at the start of each selected line"})

-- Key mapping to initiate insert mode with special handling
-- vim.keymap.set('v', 'I', function()
--   -- Exit visual mode and store the selection marks
--   vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<Esc>', true, false, true), 'x', true)
--
--   vim.defer_fn(function()
--     local start_line, end_line = vim.fn.line("'<"), vim.fn.line("'>")
--
--     -- Capture the initial content and indentation of the first line
--     local initial_line_content = vim.api.nvim_buf_get_lines(0, start_line - 1, start_line, false)[1]
--     local start_col = initial_line_content:find("%S") or 1     -- Find first non-blank character or use start of line
--
--     -- InsertLeave autocmd to apply the change across all selected lines
--     vim.cmd(string.format("autocmd InsertLeave <buffer> ++once lua _G.apply_inserted_text_to_lines(%d, %d, %d, %q)",
--       start_line, end_line, start_col, initial_line_content))
--
--     -- Move the cursor to the first non-blank character of the first selected line and enter Insert mode
--     vim.api.nvim_win_set_cursor(0, { start_line, start_col - 1 })
--     vim.cmd('startinsert')
--   end, 10)   -- Small delay to ensure visual mode has been exited
-- end, { desc = "Insert at the beginning of the selected lines" })
--
-- -- Function to apply the inserted text to each selected line
-- function _G.apply_inserted_text_to_lines(start_line, end_line, start_col, initial_content)
--   local modified_line_content = vim.api.nvim_buf_get_lines(0, start_line - 1, start_line, false)[1]
--   local inserted_text = modified_line_content:sub(start_col)
--
--   -- Apply the inserted text at the correct column for each line, preserving existing indentation
--   for line = start_line + 1, end_line do
--     local line_content = vim.api.nvim_buf_get_lines(0, line - 1, line, false)[1] or ""
--     local leading_spaces = line_content:sub(1, start_col - 1)     -- Preserve existing indentation
--     vim.api.nvim_buf_set_lines(0, line - 1, line, false, { leading_spaces .. inserted_text })
--   end

vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)

vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

vim.keymap.set("v", "<", "<gv", { noremap = true, silent = true })
vim.keymap.set("v", ">", ">gv", { noremap = true, silent = true })

vim.keymap.set("n", "J", "mzJ`z")
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")


-- -- Create new mappings for '<leader>d' and '<leader>dd' to mimic the default behavior
-- vim.keymap.set('n', '<leader>d', 'd', { noremap = true, silent = true })
-- vim.keymap.set('n', '<leader>dd', 'dd', { noremap = true, silent = true })
-- vim.keymap.set('v', '<leader>d', 'd', { noremap = true, silent = true })
-- vim.keymap.set('n', '<leader>c', 'c', { noremap = true, silent = true })
-- vim.keymap.set('v', '<leader>c', 'c', { noremap = true, silent = true })
-- -- Remap 'd' and 'dd' to the black hole register
-- vim.keymap.set('n', 'd', '"_d', { noremap = true, silent = true })
-- vim.keymap.set('n', 'dd', '"_dd', { noremap = true, silent = true })
-- vim.keymap.set('v', 'd', '"_d', { noremap = true, silent = true })
-- vim.keymap.set('n', 'x', '"_x', { noremap = true, silent = true })
-- vim.keymap.set('n', 'c', '"_c', { noremap = true, silent = true })
-- vim.keymap.set('v', 'c', '"_c', { noremap = true, silent = true })
-- === Deletion Mappings ===

-- Create new mappings for '<leader>d' and '<leader>dd' to mimic the default behavior in Normal Mode
vim.keymap.set('n', '<leader>d', 'd', { noremap = true, silent = true })
vim.keymap.set('n', '<leader>dd', 'dd', { noremap = true, silent = true })
vim.keymap.set('v', '<leader>d', 'd', { noremap = true, silent = true })

-- Remap 'd' and 'dd' to the black hole register in Normal and Visual Modes
vim.keymap.set('n', 'd', '"_d', { noremap = true, silent = true })
vim.keymap.set('n', 'dd', '"_dd', { noremap = true, silent = true })
vim.keymap.set('v', 'd', '"_d', { noremap = true, silent = true })

-- === Change Mappings ===

-- Create new mappings for '<leader>c' to mimic the default behavior in Normal and Visual Modes
vim.keymap.set('n', '<leader>c', 'c', { noremap = true, silent = true })
vim.keymap.set('v', '<leader>c', 'c', { noremap = true, silent = true })

-- Remap 'c' to the black hole register in Normal and Visual Modes
vim.keymap.set('n', 'c', '"_c', { noremap = true, silent = true })
vim.keymap.set('v', 'c', '"_c', { noremap = true, silent = true })

-- === Paste Mappings ===

-- Keep 'p' in Normal Mode as default (no mapping)

-- Visual Mode: Paste without yanking the replaced text
vim.keymap.set('v', 'p', '"_dP', { noremap = true, silent = true })

-- Leader Paste: Perform default 'p' behavior in Normal and Visual Modes
vim.keymap.set('n', '<leader>p', '<cmd>normal! p<CR>', { noremap = true, silent = true })
vim.keymap.set('v', '<leader>p', '<cmd>normal! p<CR>', { noremap = true, silent = true })


-- next greatest remap ever : asbjornHaland
-- vim.keymap.set({"n", "v"}, "<leader>y", [["+y]])
-- vim.keymap.set("n", "<leader>Y", [["+Y]])

-- vim.keymap.set({ "n", "v" }, "<leader>d", [["_d]])

-- i don't know what they do
-- vim.keymap.set("n", "<C-k>", "<cmd>cnext<CR>zz")
-- vim.keymap.set("n", "<C-j>", "<cmd>cprev<CR>zz")
-- vim.keymap.set("n", "<leader>k", "<cmd>lnext<CR>zz")
-- vim.keymap.set("n", "<leader>j", "<cmd>lprev<CR>zz")

vim.keymap.set("n", "<C-f>", "<cmd>silent !tmux neww tmux-sessionizer<CR>")

-- vim.keymap.set("n", "<C-h>", "<C-w>h")
-- vim.keymap.set("n", "<C-j>", "<C-w>j")
-- vim.keymap.set("n", "<C-k>", "<C-w>k")
-- vim.keymap.set("n", "<C-l>", "<C-w>l")


--
-- -- Create the GitVerticalSplit augroup
-- vim.api.nvim_create_augroup('GitVerticalSplit', { clear = true })

-- -- Create the autocmd for the FileType 'fugitive'
-- vim.api.nvim_create_autocmd('FileType', {
--   group = 'GitVerticalSplit',
--   pattern = 'fugitive',
--   callback = function()
--     vim.cmd('set winwidth=40')
--     vim.cmd('wincmd H')
--     -- vim.cmd('vertical resize 40') -- Set the left pane width to 30 columns (adjust as needed)
--   end,
-- })
--
-- -- Bind <leader>gg to open :Git and trigger the vertical split
-- vim.api.nvim_set_keymap("n", "<leader>gg", ":Git<CR>", { noremap = true, silent = true })
--
--
--

-- Remap for dealing with word wrap. Only when wordwrap is enabled
vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- remap going to the previous edited file
vim.keymap.set({'n', 'i'}, '<S-Tab>', '<C-^>', { noremap = true, silent = true })



