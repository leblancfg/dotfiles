require("nvim-tree").setup({
    sort = {
        sorter = "case_sensitive",
    },
    view = {
        width = 30,
    },
    filters = {
        dotfiles = false,
    },
})
vim.api.nvim_set_keymap('n', '<C-n>', ':NvimTreeToggle<CR>', { noremap = true, silent = true })

vim.g.nvim_tree_ignore = { '.git', 'egg-info', 'dist-info', '__editable__', '__pycache__' }
vim.g.nvim_tree_auto_open = 0
vim.g.nvim_tree_auto_close = 1
vim.g.nvim_tree_quit_on_open = 1

-- Show line numbers in NvimTree
vim.g.nvim_tree_disable_netrw = 0
vim.g.nvim_tree_hijack_netrw = 0
vim.cmd [[ autocmd FileType NvimTree setlocal relativenumber ]]
