vim.opt_local.textwidth = 100
vim.opt_local.formatprg = "md-fmt"

local function format_file()
    vim.cmd("normal! mB")
    local ok, err = pcall(vim.cmd, "keepmarks normal! gggqG")
    pcall(vim.cmd, "normal! `B")
    pcall(vim.cmd, "delmarks B")

    if not ok then
        error(err)
    end
end

vim.keymap.set("n", "<leader>q", format_file, { buffer = true, silent = true, desc = "Format entire markdown file" })
