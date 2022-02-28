local M = {}

M['nvim-autopairs'] = function()
    require('nvim-autopairs').setup { fast_wrap = {} }
    local cmp_autopairs = require('nvim-autopairs.completion.cmp')
    require('cmp').event:on('confirm_done', cmp_autopairs.on_confirm_done())
end
M.lsp_signature = require('lsp_signature').setup {
  bind = true,
  --doc_lines = 1,
  floating_window = false,
  fix_pos = true,
  hint_enable = true,
  hint_prefix = ' ',
  hint_scheme = 'String',
  hi_parameter = 'Search',
  max_height = 22,
  max_width = 120,
  handler_opts = {
    border = 'single',
  },
  zindex = 200,
  padding = '',
}
M.gitsigns = require('gitsigns').setup {
  signs = {
    add = { hl = 'DiffAdd', text = '│', numhl = 'GitSignsAddNr' },
    change = { hl = 'DiffChange', text = '│', numhl = 'GitSignsChangeNr' },
    delete = { hl = 'DiffDelete', text = '│', numhl = 'GitSignsDeleteNr' },
    topdelete = { hl = 'DiffDelete', text = '‾', numhl = 'GitSignsDeleteNr' },
    changedelete = { hl = 'DiffChangeDelete', text = '~', numhl = 'GitSignsChangeNr' },
  },
}
M.orgmode = require('orgmode').setup {
  org_agenda_files = { '~/my-orgs/**/*' },
  org_default_notes_file = '~/org/notes.org',
}
M.trouble = require('trouble').setup {
  height = 20,
  width = 50
}
M['todo-comments'] = require('todo-comments').setup {
  highlight = {
    keyword = 'wide'
  }
}
M.toggleterm = require('toggleterm').setup { size = 15 }
M.neogit = require('neogit').setup()
M.project_nvim = require('project_nvim').setup()
M.sniprun = require('sniprun').setup()
M.luasnip = function()
    require('luasnip.loaders.from_vscode').load()
    require('luasnip').config.set_config({ history = true, updateevents = 'TextChanged,TextChangedI' })
end

return M
