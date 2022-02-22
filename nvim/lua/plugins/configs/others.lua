require('nvim-autopairs').setup {
  fast_wrap = {}
}

local cmp_autopairs = require('nvim-autopairs.completion.cmp')
require('cmp').event:on('confirm_done', cmp_autopairs.on_confirm_done())

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
  doc_lines = 1,
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

require('gitsigns').setup {
  signs = {
    add = { hl = 'DiffAdd', text = '│', numhl = 'GitSignsAddNr' },
    change = { hl = 'DiffChange', text = '│', numhl = 'GitSignsChangeNr' },
    delete = { hl = 'DiffDelete', text = '', numhl = 'GitSignsDeleteNr' },
    topdelete = { hl = 'DiffDelete', text = '‾', numhl = 'GitSignsDeleteNr' },
    changedelete = { hl = 'DiffChangeDelete', text = '~', numhl = 'GitSignsChangeNr' },
  },
}

require('orgmode').setup {
  org_agenda_files = {'~/my-orgs/**/*'},
  org_default_notes_file = '~/org/notes.org',
}

require('trouble').setup {
  height = 20,
  width = 50
}

local base16 = require('base16')
base16(base16.themes(require('vars').theme), true)
package.loaded['core.highlights' or false] = nil
require('core.highlights')

require('todo-comments').setup {
  highlight = {
    keyword = 'wide'
  }
}
require('neogit').setup()
require('project_nvim').setup()
require('stabilize').setup()
require('focus').setup {
  excluded_filetypes = {"toggleterm", 'NvimTree'},
  excluded_buftypes = {"NvimTree"}
}
require('winshift').setup()
require('nvim-window').setup {
  chars = { 'a', 's', 'd', 'f', 'g', 'h', 'j', 'k', 'l', ';' },
  normal_hl = 'RedOnBlack',
  border = 'none'
}

require('sniprun').setup()
require('which-key').setup {
  ignore_missing = true,
  window = {
    margin = { 0, 0, 0, 0 },
    padding = { 0, 0, 0, 0 },
    winblend = 0,
    border = 'single'
  },
  layout = {
    height = { min = 1, max = 15 }, -- min and max height of the columns
    width = { min = 1, max = 50 }, -- min and max width of the columns
    spacing = 1, -- spacing between columns
  },
  key_labels = {
    ['<space>'] = 'SPC',
    ['<CR>'] = 'RET',
    ['<Tab>'] = 'TAB',
  },
  spelling = { enabled = true},
}
