vim.opt.showmode = false

vim.g.lightline = {
    colorscheme = 'tokyonight',
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
