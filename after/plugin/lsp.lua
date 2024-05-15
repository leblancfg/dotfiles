vim.api.nvim_create_augroup('AutoFormatting', {})
vim.api.nvim_create_autocmd('BufWritePre', {
    pattern = '*.py',
    group = 'AutoFormatting',
    callback = function()
        vim.lsp.buf.format()
    end,
})
require("mason").setup {
  registries = {
    "file:~/src/github.com/mason-org/mason-registry",
  }
}
