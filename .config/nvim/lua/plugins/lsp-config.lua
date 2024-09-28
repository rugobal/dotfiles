return {
  {
    "williamboman/mason.nvim",
    config = function()
      require("mason").setup()
    end
  },
  {
    "williamboman/mason-lspconfig.nvim",
    config = function()
      require("mason-lspconfig").setup({
          ensure_installed = {"lua_ls", "pyright", "jdtls", "rust_analyzer", "sqlls", "marksman", "kotlin_language_server", "quick_lint_js", "jsonls", "html", "dockerls", "docker_compose_language_service", "cssls", "clangd", "bashls", "tailwindcss", "ts_ls", "lemminx", "yamlls"}
      })
    end
  },
  {
    "neovim/nvim-lspconfig",
    config = function()
      local capabilities = require('cmp_nvim_lsp').default_capabilities()

      local lspconfig = require("lspconfig")

      lspconfig.lua_ls.setup({
        capabilities = capabilities
      })
      -- lspconfig.ts_ls.setup({}) -- typescript
      lspconfig.pyright.setup({
        capabilities = capabilities,
        settings = {
          python = {
            analysis = {
              typeCheckingMode = "off",
            },
          },
        }
      })
      lspconfig.ts_ls.setup({
        capabilities = capabilities
      })
      lspconfig.jdtls.setup({
        capabilities = capabilities
      })
      lspconfig.sqlls.setup({
        capabilities = capabilities
      })
      lspconfig.marksman.setup({
        capabilities = capabilities
      })
      lspconfig.quick_lint_js.setup({
        capabilities = capabilities
      })
      lspconfig.jsonls.setup({
        capabilities = capabilities
      })
      lspconfig.html.setup({
        capabilities = capabilities
      })
      lspconfig.cssls.setup({
        capabilities = capabilities
      })
      lspconfig.bashls.setup({
        capabilities = capabilities
      })
      lspconfig.tailwindcss.setup({
        capabilities = capabilities
      })

      vim.keymap.set("n", "K", vim.lsp.buf.hover, {})
      vim.keymap.set('n', 'gd', vim.lsp.buf.definition, {})
      vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, {})
      vim.keymap.set('n', '<leader>rr', vim.lsp.buf.references, {}) -- this will be mapped to telescope
      vim.keymap.set('n', '<leader>ic', vim.lsp.buf.incoming_calls, {}) -- this will be mapped to telescope
      vim.keymap.set('n', '<F2>', vim.lsp.buf.rename, {})
      -- vim.keymap.set('n', '<leader>s', vim.lsp.buf.workspace_symbol, {}) -- this will be mapped to telescope
      -- vim.keymap.set('n', '<leader>ds', vim.lsp.buf.document_symbol, {}) -- this will be mapped to telescope
      vim.keymap.set({ 'n', 'i' }, '<leader>p', vim.lsp.buf.signature_help, {})
      vim.keymap.set({ 'n', 'v' }, '<leader>.', vim.lsp.buf.code_action, {})

      -- map next definition to ]d and previous definition to [d
      vim.keymap.set('n', ']d', vim.diagnostic.goto_next, {})
      vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, {})
    end
  }
}
