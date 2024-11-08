return {
	"nvimtools/none-ls.nvim",
	dependencies = {
		"nvimtools/none-ls-extras.nvim",
	},
	config = function()
		local null_ls = require("null-ls")
		null_ls.setup({
			sources = {
				null_ls.builtins.formatting.stylua,
				null_ls.builtins.formatting.prettier,
				null_ls.builtins.formatting.black,
				null_ls.builtins.formatting.isort,
				-- null_ls.builtins.formatting.autoflake, -- it seems not to be supported anymore
				-- null_ls.builtins.diagnostics.eslint_d,

        -- The Refactoring library based off the Refactoring book by Martin Fowler. 
        -- Filetypes: { "go", "javascript", "lua", "python", "typescript" }
        -- Method: code_action
        -- Requires visually selecting the code you want to refactor and calling :'<,'>lua vim.lsp.buf.code_action()
        null_ls.builtins.code_actions.refactoring,

        require("none-ls.diagnostics.eslint_d"), -- requires none-ls-extras.nvim
        require("none-ls.diagnostics.cpplint"),
        require("none-ls.formatting.jq"),
        require("none-ls.code_actions.eslint_d"),
			},
		})

		vim.keymap.set("n", "<leader>gf", vim.lsp.buf.format, {})

		local range_formatting = function()
			local start_row, _ = unpack(vim.api.nvim_buf_get_mark(0, "<"))
			local end_row, _ = unpack(vim.api.nvim_buf_get_mark(0, ">"))
			vim.lsp.buf.format({
				range = {
					["start"] = { start_row, 0 },
					["end"] = { end_row, 0 },
				},
				async = true,
			})
		end

		vim.keymap.set("v", "<leader>f", range_formatting, { desc = "Range Formatting" })

		vim.keymap.set("n", "<leader>fd", function()
			vim.lsp.buf.format()
		end)

		-- sort imports and remove unused ones
		vim.api.nvim_set_keymap(
			"n",
			"<leader>oi",
			":!isort % && autoflake --in-place --remove-unused-variables --remove-all-unused-imports %<CR>:e<CR>",
			{ noremap = true, silent = true }
		) -- sorting imports with isort
	end,
}
