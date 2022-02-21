local ok, null = pcall(require, 'null-ls')
if not ok then return end

null.setup({
    sources = {
        null.builtins.formatting.stylua,
        null.builtins.diagnostics.eslint,
        null.builtins.completion.spell,
        null.builtins.completion.spell,
        null.builtins.completion.spell,
    },
})
