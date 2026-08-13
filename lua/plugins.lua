return {
    -- Drawers
    'roman/golden-ratio',
    'itchyny/lightline.vim',
    {
        -- Used for its group->role mapping only; every colour comes from
        -- lua/paraiso.lua so the editor matches the WezTerm scheme.
        'folke/tokyonight.nvim',
        lazy = false,
        priority = 1000,
        opts = {
            style = 'moon',
            on_colors = function(colors)
                local dark = vim.o.background ~= 'light'
                for k, v in pairs(require('paraiso').tokyonight_colors(dark)) do
                    colors[k] = v
                end
            end,
        },
    },
    {
        'f-person/auto-dark-mode.nvim',
        opts = {
            update_interval = 1000,
            set_dark_mode = function()
                vim.o.background = 'dark'
                vim.cmd.colorscheme('tokyonight-moon')
            end,
            set_light_mode = function()
                vim.o.background = 'light'
                vim.cmd.colorscheme('tokyonight-day')
            end,
        },
    },
    {
        "nvim-neo-tree/neo-tree.nvim",
        branch = "v3.x",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
            "MunifTanjim/nui.nvim",
            -- "3rd/image.nvim", -- Optional image support in preview window: See `# Preview Mode` for more information
        },
        opts = {
            event_handlers = {
                {
                    event = "neo_tree_buffer_enter",
                    handler = function(_)
                        vim.opt.relativenumber = true
                        vim.opt.number = true
                    end,
                },
            },
        },
    },
    -- Prose
    {
        "iamcco/markdown-preview.nvim",
        cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
        ft = { "markdown" },
        build = function() vim.fn["mkdp#util#install"]() end,
    },

    -- Tim Pope extravaganza
    'tpope/vim-sensible',
    'tpope/vim-surround',
    'tpope/vim-repeat',
    'tpope/vim-commentary',
    'tpope/vim-abolish',
    'tpope/vim-fugitive',
    'tpope/vim-projectionist',
    {
        'github/copilot.vim',
        init = function()
            vim.g.copilot_version = false
        end,
    },

    -- Treesitter
    {
        'nvim-treesitter/nvim-treesitter',
        branch = 'main',
        lazy = false,
    },
    "HiPhish/rainbow-delimiters.nvim",

    -- LSP
    {
        'VonHeikemen/lsp-zero.nvim',
        branch = 'v3.x',
        config = false,
        init = function()
            -- Disable automatic setup, we are doing it manually
            vim.g.lsp_zero_extend_cmp = 0
            vim.g.lsp_zero_extend_lspconfig = 0
        end,
    },
    {
        'williamboman/mason.nvim',
        lazy = false,
        config = true,
    },

    -- Snippets
    {
        "L3MON4D3/LuaSnip",
        version = "v2.*",
        build = "make install_jsregexp",
        keys = function()
            return {}
        end,
    },

    -- Autocompletion
    'hrsh7th/cmp-buffer',
    {
        'hrsh7th/nvim-cmp',
        event = 'InsertEnter',
        dependencies = {
            {
                'saadparwaiz1/cmp_luasnip',
            },
        },
        config = function()
            -- Here is where you configure the autocompletion settings.
            local lsp_zero = require('lsp-zero')
            lsp_zero.extend_cmp()

            -- And you can configure cmp even more, if you want to.
            local cmp = require('cmp')
            -- local cmp_action = lsp_zero.cmp_action()

            cmp.setup({
                formatting = lsp_zero.cmp_format(),
                sources = {
                    { name = 'nvim_lsp' },
                    { name = 'luasnip' },
                    { name = 'path' },
                    { name = 'buffer', option = {
                        get_bufnrs = function()
                            local buf = vim.api.nvim_get_current_buf()
                            local byte_size = vim.api.nvim_buf_get_offset(buf, vim.api.nvim_buf_line_count(buf))
                            if byte_size > 50000 then
                                return {}
                            end
                            return { buf }
                        end
                    }},
                },
            })
        end
    },
    {
        'tzachar/cmp-ai',
        dependencies = 'nvim-lua/plenary.nvim'
    },

    -- LSP — config lives in lua/lsp.lua
    {
        'neovim/nvim-lspconfig',
        cmd = { 'LspInfo', 'LspInstall', 'LspStart' },
        event = { 'BufReadPre', 'BufNewFile' },
        dependencies = {
            { 'hrsh7th/cmp-nvim-lsp' },
            { 'williamboman/mason-lspconfig.nvim' },
            { 'jose-elias-alvarez/null-ls.nvim', dependencies = { 'nvim-lua/plenary.nvim' } },
            { 'jay-babu/mason-null-ls.nvim' },
        },
        config = function()
            require('lsp')
        end
    },

    -- Move around - load appropriate plugin based on multiplexer
    (vim.fn.getenv('TMUX') ~= vim.NIL) and 'christoomey/vim-tmux-navigator' or {
        "swaits/zellij-nav.nvim",
        lazy = true,
        event = "VeryLazy",
        keys = {
            { "<c-h>", "<cmd>ZellijNavigateLeft<cr>", { silent = true, desc = "navigate left" } },
            { "<c-j>", "<cmd>ZellijNavigateDown<cr>", { silent = true, desc = "navigate down" } },
            { "<c-k>", "<cmd>ZellijNavigateUp<cr>", { silent = true, desc = "navigate up" } },
            { "<c-l>", "<cmd>ZellijNavigateRight<cr>", { silent = true, desc = "navigate right" } },
        },
        opts = {},
    },
    -- 'christoomey/vim-tmux-runner',
    {
        'nvim-telescope/telescope.nvim',
        tag = 'v0.1.9',
        dependencies = {
            'nvim-lua/plenary.nvim',
            {
                'nvim-telescope/telescope-fzf-native.nvim',
                build = 'make',
            },
        },
    },

    -- Langs
    'jjo/vim-cue',
    'MaxMEllon/vim-jsx-pretty',
    'jose-elias-alvarez/typescript.nvim',

    -- Pretties
    -- 'RRethy/nvim-base16',
    -- 'xiyaowong/transparent.nvim'
}
