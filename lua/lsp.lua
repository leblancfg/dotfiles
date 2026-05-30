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
    handlers = {
        lsp_zero.default_setup,
        basedpyright = function()
            -- Disabled — Python diagnostics come from Ruff only.
        end,
        lua_ls = function()
            local lua_opts = lsp_zero.nvim_lua_ls()
            require('lspconfig').lua_ls.setup(lua_opts)
        end,
    }
})

-- Ruby LSP is managed by each Ruby project (usually through Bundler), not Mason.
-- Mason's ruby_lsp install can be flaky across Ruby versions, and Shopify-style
-- projects already provide the right version in the bundle.
require('lspconfig').ruby_lsp.setup({
    cmd = { "bundle", "exec", "ruby-lsp" },
    filetypes = { "ruby" },
    root_dir = require('lspconfig.util').root_pattern("Gemfile", ".git"),
    init_options = {
        formatter = "rubocop",
        linters = { "rubocop" },
    },
})
