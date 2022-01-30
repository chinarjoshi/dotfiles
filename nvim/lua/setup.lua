require('telescope').setup()
require('project_nvim').setup()
require('lsp-colors').setup()
require('trouble').setup()
require('luasnip.loaders.from_vscode').load()
require('neogit').setup()
require('gitsigns').setup()
require('dapui').setup()
require('dap-python').setup('/bin/python')
require('surround').setup{ mappings_style='sandwich' }
require('nvim-autopairs').setup()
require('Comment').setup()
require('todo-comments').setup()
require('iswap').setup{}
require('nvim-web-devicons').setup()
require('lualine').setup{ options = { theme = 'onedark' } }
require('orgmode').setup()
require('spellsitter').setup()
vim.cmd [[autocmd CursorHold,CursorHoldI * lua require'nvim-lightbulb'.update_lightbulb()]]
