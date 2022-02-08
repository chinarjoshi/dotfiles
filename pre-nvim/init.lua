-- Core files
core = {
  'settings',
  'keymaps',
  'plugins'
}
-- Plugins with their own config file
long = {
  'nvim-tree',
  'indent-blankline',
  'treesitter',
  'nvim-cmp',
  'nvim-lspconfig',
  'vista',
  'others'
}
for _, file in ipairs(core) do require(file) end
for _, file in ipairs(long) do require('config.' .. file) end
