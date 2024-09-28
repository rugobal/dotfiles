return {
	"nvim-neo-tree/neo-tree.nvim",
	branch = "v3.x",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-tree/nvim-web-devicons",
		"MunifTanjim/nui.nvim",
	},
	config = function()
		vim.keymap.set("n", "<C-n>", ":Neotree filesystem reveal left toggle<CR>", {})
		-- vim.keymap.set("n", "ff", ":Neotree buffers reveal float<CR>", {}) -- This is mapped now to Telescope buffers
	end,
}
