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
  'nvim-web-devicons',
  'neogit',
  'orgmode',
}
require('impatient')
require('lualine').setup{ options = { theme = 'onedark' } }
require('luasnip.loaders.from_vscode').load()
require('iswap').setup{}

for _, plugin in ipairs(standard) do
  require(plugin).setup()
end

vim.cmd [[autocmd CursorHold,CursorHoldI * lua require'nvim-lightbulb'.update_lightbulb()]]
