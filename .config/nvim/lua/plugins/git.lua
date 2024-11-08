return {
	{
		"tpope/vim-fugitive",
    config = function()
      -- keymap for git diff and swap panes so the local changes are on the left
      -- vim.api.nvim_set_keymap("n", "<leader>gd", ":Gvdiffsplit<CR><C-w>L<C-w>h", { noremap = true, silent = true }) -- this is already mapped below with gs.diffdiss

      vim.api.nvim_set_keymap("n", "<leader>gg", ":Git<CR><C-w>H", { noremap = true, silent = true })


      -- close git diff
      vim.api.nvim_create_user_command('CloseDiff', function()
        if vim.fn.winnr() == 2 then
          vim.cmd('q | bd')
        else
          vim.cmd('q')
        end
      end, {})

      -- vim.api.nvim_set_keymap("n", "<leader>cd", ":CloseDiff<CR>", { noremap = true, silent = true })
    end
  },
	{
		"lewis6991/gitsigns.nvim",
		config = function()
			local signs = require("gitsigns")
      signs.setup {
        signs = {
          add = { text = '+' },
          change = { text = '~' },
          delete = { text = '_' },
          topdelete = { text = '‾' },
          changedelete = { text = '~' },
        },
        current_line_blame = false,
        on_attach = function(bufnr)
          local gs = package.loaded.gitsigns

          local function map(mode, l, r, opts)
            opts = opts or {}
            opts.buffer = bufnr
            vim.keymap.set(mode, l, r, opts)
          end

          -- Navigation
          map('n', ']c', function()
            vim.schedule(function() gs.next_hunk() end)
            return '<Ignore>'
          end, {expr=true})

          map('n', '[c', function()
            vim.schedule(function() gs.prev_hunk() end)
            return '<Ignore>'
          end, {expr=true})

          -- Actions
          map({'n', 'v'}, '<leader>hs', ':Gitsigns stage_hunk<CR>')
          map({'n', 'v'}, '<leader>hr', ':Gitsigns reset_hunk<CR>')
          map('n', '<leader>hS', gs.stage_buffer)
          map('n', '<leader>ha', gs.stage_hunk)
          map('n', '<leader>hu', gs.undo_stage_hunk)
          map('n', '<leader>hR', gs.reset_buffer)
          map('n', '<leader>hp', gs.preview_hunk)
          map('n', '<leader>hb', function() gs.blame_line{full=true} end)
          map('n', '<leader>tB', gs.toggle_current_line_blame)
          map('n', '<leader>hd', gs.diffthis)
          map('n', '<leader>hD', function() gs.diffthis('~') end)
          map('n', '[[', gs.prev_hunk)
          map('n', ']]', gs.next_hunk)

          -- Text object
          map({'o', 'x'}, 'ih', ':<C-U>Gitsigns select_hunk<CR>')
        end,
      }

			--vim.keymap.set("n", "<leader>hp", ":Gitsigns preview_hunk<CR>", { silent = true })
		end,
	},
}
