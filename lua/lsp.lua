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

-- Ruby LSP is managed by each Ruby project (usually through Bundler), not Mason.
-- Mason's ruby_lsp install can be flaky across Ruby versions, and Shopify-style
-- projects already provide the right version in the bundle.
vim.lsp.config('ruby_lsp', {
    cmd = { "bundle", "exec", "ruby-lsp" },
    filetypes = { "ruby" },
    root_markers = { "Gemfile", ".git" },
    init_options = {
        formatter = "rubocop",
        linters = { "rubocop" },
    },
})
vim.lsp.enable('ruby_lsp')

-- Mason: manage LSP servers and tools
require('mason').setup({})
require('mason-lspconfig').setup({
    automatic_enable = {
        exclude = { 'basedpyright' },
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
