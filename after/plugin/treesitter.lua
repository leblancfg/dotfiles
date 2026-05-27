local ok, treesitter = pcall(require, "nvim-treesitter")
if not ok then
    return
end

-- nvim-treesitter's main branch / Neovim 0.12 API no longer supports
-- require('nvim-treesitter.configs').setup { highlight = ..., ensure_installed = ... }.
treesitter.setup({})

local parsers = {
    "javascript",
    "markdown_inline",
    "typescript",
    "c",
    "lua",
    "vim",
    "query",
    "python",
    "ruby",
}

local installed = {}
local installed_ok, installed_parsers = pcall(treesitter.get_installed, "parsers")
if installed_ok then
    for _, parser in ipairs(installed_parsers) do
        installed[parser] = true
    end
end

local missing = {}
for _, parser in ipairs(parsers) do
    if not installed[parser] then
        table.insert(missing, parser)
    end
end

if #missing > 0 then
    -- Async; errors are surfaced through :checkhealth / :TSLog rather than blocking startup.
    pcall(treesitter.install, missing, { summary = true })
end

vim.api.nvim_create_autocmd("FileType", {
    group = vim.api.nvim_create_augroup("user_treesitter", { clear = true }),
    callback = function(args)
        pcall(vim.treesitter.start, args.buf)

        local lang = vim.treesitter.language.get_lang(vim.bo[args.buf].filetype)
        if not lang then
            return
        end

        local query_ok, indent_query = pcall(vim.treesitter.query.get, lang, "indents")
        if query_ok and indent_query then
            vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
        end
    end,
})
