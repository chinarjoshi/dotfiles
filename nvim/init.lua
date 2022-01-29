-- Base files
base = {
  'settings',
  'keymaps',
  'plugins',
  'setup'
}
-- Plugins with their own config file
long = {
  'indent-blankline',
  'nvim-cmp',
  'nvim-lspconfig',
  'nvim-tree',
  'vista'
}
for _, file in ipairs(base) do require(file) end
for _, file in ipairs(long) do require('config.' .. file) end
