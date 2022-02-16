require('impatient').enable_profile()

for _, module in ipairs({
   'core.settings',
   'core.autocmds',
   'core.mappings',
   'plugins'
}) do
  require(module)
end
