require('nvim-autopairs').setup { fast_wrap = {} }
require('lsp_signature').setup {
  floating_window = false,
  fix_pos = true,
  hint_enable = true,
  hint_prefix = ' ',
  hint_scheme = 'String',
  hi_parameter = 'Search',
}
require('gitsigns').setup {
  signs = {
    add = { hl = 'DiffAdd', text = '│', numhl = 'GitSignsAddNr' },
    change = { hl = 'DiffChange', text = '│', numhl = 'GitSignsChangeNr' },
    delete = { hl = 'DiffDelete', text = '│', numhl = 'GitSignsDeleteNr' },
    topdelete = { hl = 'DiffDelete', text = '‾', numhl = 'GitSignsDeleteNr' },
    changedelete = { hl = 'DiffChangeDelete', text = '~', numhl = 'GitSignsChangeNr' },
  },
}
require('orgmode').setup {
  org_agenda_files = { '~/my-orgs/**/*' },
  org_default_notes_file = '~/org/notes.org',
}
require('trouble').setup {
  height = 20,
  width = 50,
}
require('todo-comments').setup {
  highlight = {
    keyword = 'wide',
  },
}
require('toggleterm').setup { size = 15 }
require('neogit').setup()
require('project_nvim').setup()
require('sniprun').setup()
require('luasnip').config.set_config { history = true, updateevents = 'TextChanged,TextChangedI' }
require('luatab').setup()
