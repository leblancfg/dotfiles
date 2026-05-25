local telescope = require('telescope')
local builtin = require('telescope.builtin')

-- Use compiled fzf algorithm instead of Telescope's Lua sorter
telescope.load_extension('fzf')

vim.keymap.set('n', '<C-f>', builtin.live_grep, {})
-- find_files uses fd, which only sees files on disk (respects sparse checkout)
vim.keymap.set('n', '<C-p>', builtin.find_files, {})
-- vim.keymap.set('n', '<leader>fb', builtin.buffers, {})
vim.keymap.set('n', '<leader>h', builtin.help_tags, {})
