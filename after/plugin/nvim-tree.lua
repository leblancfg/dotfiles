require("neo-tree").setup({
    filesystem = {
       window = {
         mappings = {
           -- disable fuzzy finder
           ["/"] = "noop"
         }
       }
     },
})
vim.api.nvim_set_keymap('n', '<C-n>', ':Neotree toggle<CR>', { noremap = true, silent = true })

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
