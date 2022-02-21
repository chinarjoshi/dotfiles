local ok, null_ls = pcall(require, 'null-ls')
if not ok then
  return
end

null_ls.setup({
    sources = {
        require("null-ls").builtins.formatting.stylua,
        require("null-ls").builtins.diagnostics.eslint,
    },
})
