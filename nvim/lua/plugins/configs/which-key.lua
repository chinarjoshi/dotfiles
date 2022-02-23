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
  spelling = { enabled = true },
  presets = {
    operators = false,
    motions = false,
    text_objects = false,
    windows = false,
    nav = false,
    g = false,
  }
}
