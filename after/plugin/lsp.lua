local lsp_zero = require('lsp-zero')

require('lspconfig').intelephense.setup({
  on_attach = lsp_zero.on_attach,
  capabilities = lsp_zero.capabilities,
})

lsp_zero.on_attach(function(client, bufnr)
  -- see :help lsp-zero-keybindings to learn the available actions
  lsp_zero.default_keymaps({buffer = bufnr})
  if client.name == 'ruff_lsp' then
    -- Disable hover in favor of Pyright
    client.server_capabilities.hoverProvider = false
  end
end)



lsp_zero.format_on_save({
    format_opts = {
        async = false,
        timeout_ms = 10000,
    },
    servers = {
        ['null-ls'] = {'javascript', 'typescript', 'typescriptreact', 'jsx', 'css'},
        ['ruff-lsp'] = {'python'},
    },
})

-- to learn how to use mason.nvim with lsp-zero
-- read this: https://github.com/VonHeikemen/lsp-zero.nvim/blob/v3.x/doc/md/guide/integrate-with-mason-nvim.md
require('mason').setup({})
require('mason-lspconfig').setup({
  ensure_installed = {
      "lua_ls",
      "tsserver",
  },
  handlers = {
    lsp_zero.default_setup,
    pyright = function()
      require('lspconfig').pyright.setup({
        -- on_attach = on_attach,
        settings = {
          pyright = {
            -- Using Ruff's import organizer
            disableOrganizeImports = true,
          },
          python = {
            analysis = {
              -- Ignore all files for analysis to exclusively use Ruff for linting
              ignore = { '*' },
            },
          },
        },
      })
    end
  },
})
