-- Attempt to fix colors
-- Ah but just terminal colors is much less jarring. No fancy colors but shit's behaved.
-- vim.opt.termguicolors = true

-- Swapfiles are more trouble than they're worth
vim.opt.swapfile = false

-- Highlights
-- Nothing during search
vim.opt.hlsearch = false
-- But match parens, brackets, etc.
vim.opt.showmatch = true

-- Show hybrid relative line numbers
vim.opt.relativenumber = true
vim.opt.number = true

-- Show fancy glyphs
vim.opt.encoding = "UTF-8"

-- Mouse
vim.opt.mouse = "a"
if vim.fn.has("mouse_sgr") == 1 then
    vim.opt.ttymouse = "sgr"
else
    if vim.fn.has('nvim') == 0 then
        vim.opt.ttymouse = "xterm2"
    end
end

-- Filetypes
vim.cmd('filetype on')
vim.cmd('filetype plugin on')

-- Tabs are 4 spaces, natch.
-- Only do this part when compiled with support for autocommands.
-- TODO: Eventually move this to a separate file for each filetype.
if vim.fn.has("autocmd") == 1 then
    -- Use filetype detection and file-based automatic indenting.
    vim.cmd('filetype plugin indent on')

    -- Use actual tab chars in CUE and Makefiles
    vim.cmd('autocmd FileType make set tabstop=8 shiftwidth=8 softtabstop=0 noexpandtab')
    vim.cmd('autocmd FileType cue set tabstop=4 shiftwidth=4 softtabstop=0 noexpandtab')
end

-- For everything else, use a tab width of 4 space chars.
-- FIXME: This sucks for 2-space SQL and TS. 
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.softtabstop = 4
vim.opt.expandtab = true

-- Reload indent file after each save
vim.cmd('filetype plugin indent on')

-- Always reload the newest file, even if that means overwriting
vim.opt.autoread = true
--
-- Disable netrw
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
