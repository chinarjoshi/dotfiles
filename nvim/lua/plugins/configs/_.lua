local M = {}

M.nvim_autopairs = require('nvim-autopairs').setup { fast_wrap = {} }
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
M.todo_comments = require('todo-comments').setup {
  highlight = {
    keyword = 'wide'
  }
}
M.toggleterm = require('toggleterm').setup { size = 15 }
M.neogit = require('neogit').setup()
M.project_nvim = require('project_nvim').setup()
M.sniprun = require('sniprun').setup()
M.luasnip = require('luasnip').config.set_config({ history = true, updateevents = 'TextChanged,TextChangedI' })

return M
