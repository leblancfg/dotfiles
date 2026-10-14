local telescope = require('telescope')
local builtin = require('telescope.builtin')

local function project_root()
    local buffer_path = vim.api.nvim_buf_get_name(0)
    local start_path = buffer_path ~= '' and buffer_path or vim.uv.cwd()
    return vim.fs.root(start_path, '.git') or vim.uv.cwd()
end

-- Use compiled fzf algorithm instead of Telescope's Lua sorter
telescope.load_extension('fzf')

vim.keymap.set('n', '<C-f>', function()
    builtin.live_grep({ cwd = project_root() })
end, {})
-- find_files uses fd, which only sees files on disk (respects sparse checkout)
vim.keymap.set('n', '<C-p>', function()
    builtin.find_files({ cwd = project_root() })
end, {})
-- vim.keymap.set('n', '<leader>fb', builtin.buffers, {})
vim.keymap.set('n', '<leader>h', builtin.help_tags, {})
