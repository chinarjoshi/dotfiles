require('impatient').enable_profile()

for _, module in ipairs({
   "core.settings",
   "core.autocmds",
   "plugins"
}) do
  require(module)
end
