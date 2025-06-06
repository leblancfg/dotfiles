-- Ruby-specific settings
vim.opt_local.shiftwidth = 2  -- Use 2 spaces for indentation (Ruby convention)
vim.opt_local.tabstop = 2
vim.opt_local.softtabstop = 2
vim.opt_local.expandtab = true

-- Set comment string for Ruby
vim.opt_local.commentstring = '# %s'

-- Add Ruby-specific keybindings if needed
-- For example, you could add a mapping to run the current Ruby file
vim.api.nvim_buf_set_keymap(0, 'n', '<leader>rr', ':!ruby %<CR>', { noremap = true, silent = true })