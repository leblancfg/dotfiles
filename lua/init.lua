require("rc")
require("maps")

vim.opt.termguicolors = true

local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system {
        'git',
        'clone',
        '--filter=blob:none',
        '--single-branch',
        'https://github.com/folke/lazy.nvim.git',
        lazypath,
    }
end

vim.opt.runtimepath:prepend(lazypath)
require('lazy').setup('plugins', {
    change_detection = {
        enabled = true,
        notify = false,
    },
    checker = {
        enabled = true,
        notify = false,
    },
    performance = {
        rtp = {
            disabled_plugins = {
                'gzip',
                -- 'matchit',
                -- 'matchparen',
                'netrwPlugin',
                'tarPlugin',
                'tohtml',
                'tutor',
                'zipPlugin',
            },
        },
    },
})

vim.cmd[[colorscheme tokyonight]]

-- Ensure Zellij returns to normal mode when exiting NeoVim
vim.api.nvim_create_autocmd("VimLeave", {
    pattern = "*",
    command = "silent !zellij action switch-mode normal"
})
