local present, impatient = pcall(require, 'impatient')

if present then
  impatient.enable_profile()
end

for _, module in ipairs({
   'core.settings',
   'core.mappings',
   'plugins',
}) do
  local ok, err = pcall(require, module)
  if not ok then
    error('\n\nError loading \'' .. module .. '\' in init.lua\n\n' .. err)
  end
end
