return {
	{
		"lukas-reineke/indent-blankline.nvim",
		main = "ibl",
		opts = {},

		config = function()
			require("ibl").setup()
		end,
	},
	{
		"kevinhwang91/nvim-ufo",
		dependencies = "kevinhwang91/promise-async",
		config = function()
			vim.o.foldcolumn = "1" -- '0' is not bad
			vim.o.foldlevel = 99 -- Using ufo provider need a large value, feel free to decrease the value
			vim.o.foldlevelstart = 99
			vim.o.foldenable = true

      -- The Neovim built-in folding commands are za to toggle a fold, zc to close a fold, and zo to open one
      -- Remap za (toggle fold) to fa
      vim.keymap.set('n', 'fa', 'za', { noremap = true, silent = true })

      -- Remap zo (open fold) to fo
      vim.keymap.set('n', 'fo', 'zo', { noremap = true, silent = true })

      -- Remap zc (close fold) to fc
      vim.keymap.set('n', 'fc', 'zc', { noremap = true, silent = true })

			-- Using ufo provider need remap `zR` and `zM`. If Neovim is 0.6.1, remap yourself
			vim.keymap.set("n", "fR", require("ufo").openAllFolds)
			vim.keymap.set("n", "fM", require("ufo").closeAllFolds)
			vim.keymap.set("n", "fK", function()
				local winid = require("ufo").peekFoldedLinesUnderCursor()
				if not winid then
					vim.lsp.buf.hover()
				end
			end, { desc = "Peek Fold" })

			require("ufo").setup({
				provider_selector = function(bufnr, filetype, buftype)
					return { "lsp", "indent" }
				end,
			})
		end,
	},
}
