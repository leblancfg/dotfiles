-- Set custom maps
vim.g.mapleader = ","
vim.api.nvim_set_keymap('', '<Bslash>', 'gt', {})

-- Remove this footgun I never use
vim.keymap.set("n", "Q", "<nop>")
vim.keymap.set('n', 'QQ', ':qa!<CR>')

-- Copy-paste, works with Cygwin and mouse-enabled X Server on Linux
-- vim.api.nvim_set_keymap('n', '<leader>y', '"+y', { noremap = true, silent = true })
vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]])
-- vim.api.nvim_set_keymap('n', '<leader>p', '"+p', { noremap = true, silent = true })

-- Avoid RSI writing ERB files
vim.api.nvim_set_keymap('i', '<C-l>', '<%<space>', {})
vim.api.nvim_set_keymap('i', '<C-f>', '%><space>', {})

-- Switch between previous buffer
vim.api.nvim_set_keymap('n', '<leader><leader>', '<c-^>', {})

-- Toggle Paste for Insert mode
vim.api.nvim_set_keymap('n', '<leader>p', ':set paste!<CR>', {})

-- Formatting
vim.api.nvim_set_keymap('n', '<F6>', ':let _s=@/ <Bar> :%s/\\s\\+$//e <Bar> :let @/=_s <Bar> :nohl <Bar> :unlet _s <CR>',
    { silent = true })
vim.keymap.set("n", "<leader>f", vim.lsp.buf.format)

-- Insert breakpoint
vim.g.breakpoint_str = "# fmt: off\nimport ipdb; ipdb.set_trace()  # noqa: E702, E402\n# fmt: on\n"
vim.api.nvim_set_keymap('n', '<Leader>b', 'm`O<ESC> :put =breakpoint_str<CR> 4kd2d2j0<Esc>', {})

-- Easier .vimrc refresh
vim.api.nvim_set_keymap('n', '<Leader><C-r>', ':so $MYVIMRC<CR>', {})

-- Handy way to insert UTC timestamp
vim.api.nvim_set_keymap('n', '<Leader>d', ':r! date "+\\%Y-\\%m-\\%d"<CR>', {})
vim.api.nvim_set_keymap('n', '<Leader>D', 'o## <Esc>:r! date "+\\%Y-\\%m-\\%d"<CR>0i<BS><Esc>', {})

-- Search and replace word under cursor
vim.api.nvim_set_keymap('n', '<Leader>S', ':%s/\\<<C-r><C-w>\\>/', {})

-- Put an X in the checkmark on that line
vim.api.nvim_set_keymap('n', '<leader>x', '0f[lsX<Esc>', {})

-- Markdown to PDF and launch
vim.api.nvim_set_keymap('n', '<Leader>z',
    ':w<CR> :AsyncRun pandoc % -o %:r.pdf --highlight-style zenburn --variable urlcolor=cyan && open %:r.pdf<CR>', {})

-- Pandoc metadata block header
vim.g.metadataBlock = "---\ntitle: Insert Title Here\nauthor: François Leblanc\ndate: \n..."
vim.api.nvim_set_keymap('n', '<Leader>m', 'ggm`O<ESC> :put =metadataBlock<CR> ggd2djfI', {})

-- New checkmarked line
vim.api.nvim_set_keymap('n', '<leader>c', 'o* [ ] <Esc><<A', {})

-- Create new tab
vim.api.nvim_set_keymap('n', '<leader><space>', ':tabnew<CR>', {})

-- Jump to definition in vsp, aka<C-WV> <gf>
vim.api.nvim_set_keymap('n', '<leader>gd', '<C-W><C-v>gd', {})

-- Jump to diagnostics
vim.keymap.set('n', 'gl', '<cmd>lua vim.diagnostic.open_float()<cr>')
vim.keymap.set('n', '<leader>aj', '<cmd>lua vim.diagnostic.goto_next()<cr>')
vim.keymap.set('n', '<leader>ak', '<cmd>lua vim.diagnostic.goto_prev()<cr>')

-- Projections
vim.keymap.set('n', '<Leader>a', '<cmd>A<CR>')
vim.keymap.set('n', '<Leader>as', '<cmd>AS<CR>')
vim.keymap.set('n', '<Leader>av', '<cmd>AV<CR>')
vim.keymap.set('n', '<Leader>at', '<cmd>AT<CR>')

-- Get model name in dbt files
function Get_file_name_without_extension()
    local filename = vim.fn.expand('%:t:r')
    vim.fn.system('pbcopy', filename)
    print('Copied: ' .. filename)
end

vim.api.nvim_set_keymap('n', '<leader>o', ':lua Get_file_name_without_extension()<CR>', { noremap = true, silent = true })
