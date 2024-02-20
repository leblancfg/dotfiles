local cmp = require('cmp')
-- local cmp_action = require('lsp-zero').cmp_action()
local cmp_ai = require('cmp_ai.config')

cmp_ai:setup({
    max_lines = 100,
    provider = 'Ollama',
    provider_options = {
        model = 'cuelang',
    },
    notify = true,
    notify_callback = function(msg)
        vim.notify(msg)
    end,
    run_on_every_keystroke = true,
    ignored_file_types = {
        -- default is not to ignore
        -- uncomment to ignore in lua:
        -- lua = true
    },
})

cmp.setup({
    sources = cmp.config.sources({
        { name = 'nvim_lsp' },
        { name = 'luasnip' },
        { name = 'path' },
    }, {
        { name = 'buffer' },
    }
    ),
    -- mapping = cmp.mapping.preset.insert({
    -- ['<C-n>'] = cmp_action.luasnip_supertab(),
    -- ['<C-p>'] = cmp_action.luasnip_shift_supertab(),
    -- }),
    snippet = {
        expand = function(args)
            require('luasnip').lsp_expand(args.body)
        end,
    },
})
