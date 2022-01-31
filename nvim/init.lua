-- Base files
base = {
  'settings',
  'keymaps',
  'plugins'
}
-- Plugins with their own config file
long = {
  'nvim-tree',
  'indent-blankline',
  'nvim-cmp',
  'nvim-lspconfig',
  'vista',
  'others'
}
for _, file in ipairs(base) do require(file) end
for _, file in ipairs(long) do require('config.' .. file) end
