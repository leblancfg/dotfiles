vim.opt_local.textwidth = 100
vim.opt_local.formatprg = "md-fmt"

vim.api.nvim_buf_set_keymap(0, "n", "<leader>q", "gggqG``", { noremap = true, silent = true, desc = "Format entire markdown file" })
