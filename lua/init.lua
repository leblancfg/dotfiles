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

-- Runs before the first colorscheme call so the initial load is snapped too.
-- auto-dark-mode re-invokes :colorscheme, which fires this again.
vim.api.nvim_create_autocmd('ColorScheme', {
    callback = function()
        require('paraiso').enforce(vim.o.background ~= 'light')
    end,
})

vim.cmd.colorscheme('tokyonight-moon')

-- Ensure Zellij returns to normal mode when exiting NeoVim
if vim.fn.getenv('ZELLIJ') ~= vim.NIL then
    vim.api.nvim_create_autocmd("VimLeave", {
        pattern = "*",
        command = "silent !zellij action switch-mode normal"
    })
end
