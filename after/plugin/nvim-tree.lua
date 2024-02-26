require("nvim-tree").setup({
    sort = {
        sorter = "case_sensitive",
    },
    view = {
        width = 30,
        number = true,
        relativenumber = true,
    },
    filters = {
        dotfiles = true,
    },
})
vim.api.nvim_set_keymap('n', '<C-n>', ':NvimTreeToggle<CR>', { noremap = true, silent = true })

vim.g.nvim_tree_ignore = { '.git', 'egg-info', 'dist-info', '__editable__', '__pycache__' }
vim.g.nvim_tree_auto_open = 0
vim.g.nvim_tree_auto_close = 1
vim.g.nvim_tree_quit_on_open = 1
vim.g.nvim_tree_disable_netrw = 0
vim.g.nvim_tree_hijack_netrw = 0

-- No color on icons
require('nvim-web-devicons').setup {
    color_icons = false,
}
