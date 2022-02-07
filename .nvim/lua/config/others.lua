-----------------------------------------------------------
-- Other plugin configuration
-----------------------------------------------------------

standard = {
  'gitsigns',
  'telescope',
  'project_nvim',
  'trouble',
  'nvim-autopairs',
  'todo-comments',
  'neogit',
  'orgmode',
}
require('impatient')
require('luasnip.loaders.from_vscode').load()
require('iswap').setup{}

for _, plugin in ipairs(standard) do
  require(plugin).setup()
end

vim.cmd [[autocmd CursorHold,CursorHoldI * lua require'nvim-lightbulb'.update_lightbulb()]]
