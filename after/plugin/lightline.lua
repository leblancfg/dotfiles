vim.opt.showmode = false

-- Publish the palette under g:lightline#colorscheme#paraiso#palette. lightline
-- reads that global directly (autoload/lightline.vim:197), so vendoring the
-- theme needs no autoload/ file and drops the dependency on the one
-- tokyonight.nvim ships.
local function apply_palette()
    local palette = require('paraiso').lightline_palette(vim.o.background ~= 'light')
    vim.g['lightline#colorscheme#paraiso#palette'] =
        vim.fn['lightline#colorscheme#fill'](palette)
    if vim.fn.exists('*lightline#colorscheme') == 1 then
        vim.fn['lightline#colorscheme']()
    end
end

apply_palette()
vim.api.nvim_create_autocmd('ColorScheme', { callback = apply_palette })

vim.g.lightline = {
    colorscheme = 'paraiso',
    active = {
        left = { { 'mode', 'paste' }, { 'fugitive', 'readonly', 'filename', 'modified' } },
        right = { { 'lineinfo' }, { 'percent' } }
    },
    component = {
        readonly = '%{&filetype=="help"?"":&readonly?"\u{e0a2}":""}',
        modified = '%{&filetype=="help"?"":&modified?"\u{e0a0}":&modifiable?"":"-"}',
        fugitive = '%{exists("*fugitive#head")?fugitive#head():""}'
    },
    component_visible_condition = {
        readonly = '(&filetype!="help"&& &readonly)',
        modified = '(&filetype!="help"&&(&modified||!&modifiable))',
        fugitive = '(exists("*fugitive#head") && ""!=fugitive#head())'
    },
    separator = { left = "\u{e0b0}", right = "\u{e0b2}" },
    subseparator = { left = "\u{e0b1}", right = "\u{e0b3}" }
}
