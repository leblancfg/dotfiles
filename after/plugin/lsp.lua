vim.api.nvim_create_augroup('AutoFormatting', {})
vim.api.nvim_create_autocmd('BufWritePre', {
    pattern = '*.py',
    group = 'AutoFormatting',
    callback = function()
        vim.lsp.buf.format()
    end,
})
vim.api.nvim_create_autocmd({"BufRead", "BufNewFile"}, {
    pattern = "*.ino",
    callback = function()
        vim.bo.filetype = "cpp"
    end,
})
