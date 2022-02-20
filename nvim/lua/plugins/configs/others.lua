require('nvim-autopairs').setup {
  fast_wrap = {}
}

local cmp_autopairs = require('nvim-autopairs.completion.cmp')
require('cmp').event:on('confirm_done', cmp_autopairs.on_confirm_done())

require('indent_blankline').setup {
  indentLine_enabled = 1,
  char = '▏',
  filetype_exclude = {
    'help',
    'terminal',
    'packer',
    'lspinfo',
    'TelescopePrompt',
    'TelescopeResults',
    'lsp-installer',
  },
  buftype_exclude = { 'terminal' },
  show_trailing_blankline_indent = false,
  show_first_indent_level = false,
}

require('colorizer').setup({'*'}, {
  RGB = true,
  RRGGBB = true,
  names = false,
  RRGGBBAA = false,
  rgb_fn = false,
  hsl_fn = false,
  css = false,
  css_fn = false,
  mode = 'background',
})

require('luasnip.loaders.from_vscode').load()
require('luasnip').config.set_config({
  history = true,
  updateevents = 'TextChanged,TextChangedI'
})

require('lsp_signature').setup {
  bind = true,
  doc_lines = 0,
  floating_window = true,
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

require('gitsigns').setup {
  signs = {
    add = { hl = 'DiffAdd', text = '│', numhl = 'GitSignsAddNr' },
    change = { hl = 'DiffChange', text = '│', numhl = 'GitSignsChangeNr' },
    delete = { hl = 'DiffDelete', text = '', numhl = 'GitSignsDeleteNr' },
    topdelete = { hl = 'DiffDelete', text = '‾', numhl = 'GitSignsDeleteNr' },
    changedelete = { hl = 'DiffChangeDelete', text = '~', numhl = 'GitSignsChangeNr' },
  },
}

require('which-key').setup {
  ignore_missing = true,
  window = {
    margin = { 0, 0, 0, 0 }, -- margin [top, right, bottom, left]
    padding = { 1, 1, 1, 1 }, -- padding [top, right, bottom, left]
    winblend = 0
  },
  layout = {
    height = { min = 4, max = 25 }, -- min and max height of the columns
    width = { min = 20, max = 50 }, -- min and max width of the columns
    spacing = 3, -- spacing between columns
  },
  key_labels = {
    ['<space>'] = 'SPC',
    ['<CR>'] = 'RET',
    ['<tab>'] = 'TAB',
  },
  spelling = { enabled = true},
}

require('orgmode').setup {
  org_agenda_files = {'~/my-orgs/**/*'},
  org_default_notes_file = '~/org/notes.org',
}

require('nvim-lsp-installer').on_server_ready(function(server)
    server:setup({})
end)

require('trouble').setup {
  height = 20,
  width = 50
}


local base16 = require('base16')
base16(base16.themes('onedark'), true)
package.loaded['core.highlights' or false] = nil
require('core.highlights')

require('todo-comments').setup {
  highlight = {
    keyword = 'wide'
  }
}
require('neogit').setup()
require('project_nvim').setup()
