return {
	{
		"akinsho/toggleterm.nvim",
		version = "*",
		config = function()
			require("toggleterm").setup({
				size = 22,
				open_mapping = [[<c-t>]],
				hide_numbers = true,
				-- Add any additional configuration options you need here
			})

			function _G.set_terminal_keymaps()
				local opts = { buffer = 0 }
				-- vim.keymap.set("t", "<esc>", [[<C-\><C-n>]], opts)
				vim.keymap.set("t", "<C-w>", [[<C-\><C-n><C-w>]], opts)
				vim.keymap.set("t", "<C-k>", [[<C-\><C-n><C-w>k]], opts)
			end

			-- if you only want these mappings for toggle term use term://*toggleterm#* instead
			vim.cmd("autocmd! TermOpen term://* lua set_terminal_keymaps()")

			local Terminal = require("toggleterm.terminal").Terminal
			local lazygit = Terminal:new({ cmd = "lazygit", hidden = true, direction = "float" })

			function _lazygit_toggle()
				lazygit:toggle()
			end

			vim.api.nvim_set_keymap( "n", "<leader>lg", "<cmd>lua _lazygit_toggle()<CR>", { noremap = true, silent = true })
		end,
	},
}
