require('impatient').enable_profile()

for _, module in ipairs({
   "core.options",
   "core.autocmds",
   "plugins"
}) do
  require(module)
end
