return {
	"stevearc/aerial.nvim",
	opts = {},
	-- Optional dependencies
	dependencies = {
		"nvim-treesitter/nvim-treesitter",
		"nvim-tree/nvim-web-devicons",
	},
	config = function()
		require("aerial").setup({
			-- filter_kind = false,  -- Show all symbol kinds, including variables
			layout = {
				default_direction = "left", -- Sets the Aerial window to open on the left side
			},
			-- optionally use on_attach to set keymaps when aerial has attached to a buffer
			on_attach = function(bufnr)
				-- Jump forwards/backwards with '{' and '}'
				vim.keymap.set("n", "{", "<cmd>AerialPrev<CR>", { buffer = bufnr })
				vim.keymap.set("n", "}", "<cmd>AerialNext<CR>", { buffer = bufnr })
			end,
		})
		-- You probably also want to set a keymap to toggle aerial
		vim.keymap.set("n", "<leader>m", "<cmd>AerialToggle<CR>")
		-- vim.keymap.set("n", "<leader>m", "<cmd>AerialToggle!<CR>") -- the ! will keep the cursor on the editor buffer
	end,
}
