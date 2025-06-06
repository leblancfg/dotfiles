-- Ruby Language Server configuration
local lspconfig = require('lspconfig')

-- Helper function to find executable in path
local function find_executable(cmd)
    local handle = io.popen("which " .. cmd .. " 2>/dev/null")
    if not handle then return nil end
    
    local result = handle:read("*a")
    handle:close()
    
    if result and result ~= "" then
        return string.gsub(result, "[\n\r]", "")
    end
    
    return nil
end

-- Helper function to switch Ruby to a specific version using chruby
local function use_ruby_version(version)
    -- Create a function that loads the Ruby version before running the command
    return function(command)
        return {
            "bash", "-c", 
            string.format("source /opt/dev/sh/chruby/chruby.sh && chruby %s && %s", version, command)
        }
    end
end

-- Use ruby 3.3.6 for all Ruby LSP tools
local use_ruby_336 = use_ruby_version("3.3.6")

-- Configure ruby-lsp
if find_executable("ruby-lsp") then
    lspconfig.ruby_lsp.setup({
        cmd = use_ruby_336("ruby-lsp"),
        filetypes = { "ruby" },
        root_dir = lspconfig.util.root_pattern("Gemfile", ".git"),
    })
end

-- Configure solargraph if available
if find_executable("solargraph") then
    lspconfig.solargraph.setup({
        cmd = use_ruby_336("solargraph stdio"),
        filetypes = { "ruby" },
        root_dir = lspconfig.util.root_pattern("Gemfile", ".git"),
        settings = {
            solargraph = {
                diagnostics = true,
                completion = true,
            }
        }
    })
end

-- Configure standardrb if available
if find_executable("standardrb") then
    lspconfig.standardrb.setup({
        cmd = use_ruby_336("standardrb --lsp"),
        filetypes = { "ruby" },
        root_dir = lspconfig.util.root_pattern("Gemfile", ".git"),
    })
end

-- Add Ruby format on save
vim.api.nvim_create_autocmd('BufWritePre', {
    pattern = '*.rb',
    callback = function()
        vim.lsp.buf.format()
    end,
    group = vim.api.nvim_create_augroup('RubyFormatting', {}),
})