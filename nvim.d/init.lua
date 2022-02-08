require('impatient').enable_profile()
require("core.mappings").misc()

for _, module in ipairs({
   "core.options",
   "core.autocmds",
   "core.mappings",
}) do
    require(module)
end
