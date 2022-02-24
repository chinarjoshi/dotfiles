local configs = {
    ['nvim-autopairs'] = { fast_wrap = {} },
    lsp_signature = {
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
    },
    gitsigns = {
      signs = {
        add = { hl = 'DiffAdd', text = '│', numhl = 'GitSignsAddNr' },
        change = { hl = 'DiffChange', text = '│', numhl = 'GitSignsChangeNr' },
        delete = { hl = 'DiffDelete', text = '', numhl = 'GitSignsDeleteNr' },
        topdelete = { hl = 'DiffDelete', text = '‾', numhl = 'GitSignsDeleteNr' },
        changedelete = { hl = 'DiffChangeDelete', text = '~', numhl = 'GitSignsChangeNr' },
      },
    },
    orgmode = {
      org_agenda_files = { '~/my-orgs/**/*' },
      org_default_notes_file = '~/org/notes.org',
    },
    trouble = {
      height = 20,
      width = 50
    },
    ['todo-comments'] = {
      highlight = {
        keyword = 'wide'
      }
    },
    toggleterm = {
        size = 15
    }
}

for _, name in ipairs({
    'nvim-autopairs',
    'lsp_signature',
    'gitsigns',
    'trouble',
    'orgmode',
    'todo-comments',
    'neogit',
    'project_nvim',
    'sniprun',
    'toggleterm',
}) do
    local ok, plugin = pcall(require, name)
    if not ok then
        return
    end
    plugin.setup(configs[name] or {})
end

local cmp_autopairs = require('nvim-autopairs.completion.cmp')
require('cmp').event:on('confirm_done', cmp_autopairs.on_confirm_done())
require('luasnip.loaders.from_vscode').load()
require('luasnip').config.set_config({ history = true, updateevents = 'TextChanged,TextChangedI' })
