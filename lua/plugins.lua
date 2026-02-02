return {
    -- Drawers
    'roman/golden-ratio',
    'itchyny/lightline.vim',
    'mike-hearn/base16-vim-lightline',
    {
        "f-person/auto-dark-mode.nvim",
        config = {
            update_interval = 1000,
            set_dark_mode = function()
                vim.o.background = 'dark'
                -- vim.api.nvim_set_option("background", "dark")
                -- vim.cmd("colorscheme gruvbox")
            end,
            set_light_mode = function()
                vim.o.background = 'light'
                -- vim.api.nvim_set_option("background", "light")
                -- vim.cmd("colorscheme gruvbox")
            end,
        },
    },
    {
        "folke/tokyonight.nvim",
        lazy = false,
        priority = 1000,
        opts = { style = 'moon' },
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
    'github/copilot.vim',

    -- Treesitter
    'nvim-treesitter/nvim-treesitter',
    -- 'nvim-treesitter.configs',
    "HiPhish/nvim-ts-rainbow2",

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

    -- LSP
    {
        'neovim/nvim-lspconfig',
        cmd = { 'LspInfo', 'LspInstall', 'LspStart' },
        event = { 'BufReadPre', 'BufNewFile' },
        dependencies = {
            { 'hrsh7th/cmp-nvim-lsp' },
            { 'williamboman/mason-lspconfig.nvim' },
            { 'jose-elias-alvarez/null-ls.nvim' },
            { 'jay-babu/mason-null-ls.nvim' },
        },
        config = function()
            -- This is where all the LSP shenanigans will live
            local lsp_zero = require('lsp-zero')
            lsp_zero.extend_lspconfig()

            --- if you want to know more about lsp-zero and mason.nvim
            --- read this: https://github.com/VonHeikemen/lsp-zero.nvim/blob/v3.x/doc/md/guides/integrate-with-mason-nvim.md
            lsp_zero.on_attach(function(client, bufnr)
                -- see :help lsp-zero-keybindings
                -- to learn the available actions
                lsp_zero.default_keymaps({ buffer = bufnr })
                if client.name == 'ruff' then
                    -- Disable hover in favor of BasedPyright
                    client.server_capabilities.hoverProvider = false
                end
            end)

            lsp_zero.format_on_save({
                format_opts = {
                    async = true,
                    timeout_ms = 10000,
                },
                servers = {
                    ['null-ls'] = { 'javascript', 'typescript', 'typescriptreact', 'jsx', 'css', 'rust', 'sql' },
                },
            })

            require('mason').setup({})
            require('mason-lspconfig').setup({
                ensure_installed = {
                    'eslint',
                    'html',
                    'cssls',
                    'ruff',
                    'basedpyright',
                    'ruby_lsp',
                    'ts_ls',
                    'clangd',
                },
                handlers = {
                    lsp_zero.default_setup,
                    basedpyright = function()
                        require('lspconfig').basedpyright.setup({
                            settings = {
                                basedpyright = {
                                    disableOrganizeImports = true,
                                },
                                python = {
                                    analysis = {
                                        typeCheckingMode = 'basic',
                                    },
                                },
                            },
                        })
                    end,
                    lua_ls = function()
                        -- (Optional) Configure lua language server for neovim
                        local lua_opts = lsp_zero.nvim_lua_ls()
                        require('lspconfig').lua_ls.setup(lua_opts)
                    end,
                    ruby_lsp = function()
                        require('lspconfig').ruby_lsp.setup({
                            cmd = { "bundle", "exec", "ruby-lsp" },
                            filetypes = { "ruby" },
                            root_dir = require('lspconfig.util').root_pattern("Gemfile", ".git"),
                            init_options = {
                                formatter = "rubocop",
                                linters = { "rubocop" },
                            },
                        })
                    end,
                }
            })
        end
    },

    {
        "jose-elias-alvarez/null-ls.nvim",
        dependencies = { "nvim-lua/plenary.nvim" },
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
        tag = '0.1.5',
        dependencies = { 'nvim-lua/plenary.nvim' },
    },

    -- Langs
    'jjo/vim-cue',
    'MaxMEllon/vim-jsx-pretty',
    'jose-elias-alvarez/typescript.nvim',

    -- Pretties
    -- 'RRethy/nvim-base16',
    -- 'xiyaowong/transparent.nvim',
    {
        'norcalli/nvim-colorizer.lua',
        config = function()
            require('colorizer').setup()
        end,
    }
}
