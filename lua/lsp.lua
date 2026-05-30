-- LSP configuration (extracted from plugins.lua for readability)

local lsp_zero = require('lsp-zero')
lsp_zero.extend_lspconfig()

-- Per-server attach hooks
lsp_zero.on_attach(function(client, bufnr)
    lsp_zero.default_keymaps({ buffer = bufnr })
    if client.name == 'ruff' then
        -- Let the Python type server own hover while Ruff handles linting.
        client.server_capabilities.hoverProvider = false
    end
end)

-- Format on save
lsp_zero.format_on_save({
    format_opts = {
        async = true,
        timeout_ms = 10000,
    },
    servers = {
        ['null-ls'] = { 'javascript', 'typescript', 'typescriptreact', 'jsx', 'css', 'rust', 'sql' },
    },
})

-- Neovim 0.11+ LSP configuration. Avoid require('lspconfig').server.setup(),
-- which now emits deprecation warnings in nvim-lspconfig.
vim.lsp.config('lua_ls', lsp_zero.nvim_lua_ls())

-- Ruby LSP is intentionally disabled for now. Re-enable when actively working
-- in a Ruby codebase; project-local Bundler/Ruby version mismatches make it
-- noisier than useful otherwise.

-- Mason: manage LSP servers and tools
require('mason').setup({})
require('mason-lspconfig').setup({
    automatic_enable = {
        exclude = { 'basedpyright', 'ruby_lsp' },
    },
    ensure_installed = {
        'eslint',
        'html',
        'cssls',
        'ruff',
        'ty',
        'lua_ls',
        'ts_ls',
        'clangd',
    },
})
