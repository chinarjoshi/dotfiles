require('impatient').enable_profile()

for _, module in ipairs({
   'core.options',
   'core.autocmds',
   'core.mappings',
}) do
    require(module)
end
