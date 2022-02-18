require('whichkey_setup').register_keymap('leader', {
  q = {},
  f = {
    name = 'File',
    f = { '<cmd>Telescope<cr>', 'Find'},

    t = { '<cmd>NvimTreeToggle<cr>', 'Tree' },

  },

  n = {
    name = 'Notes',
  },

  t = {
    name = 'Terminals',
    t = { '<cmd>Term<cr>', 'Terminal' },
  },

  p = {
    name = 'Projects'
  },

  c = { '<cmd>noh<cr>', 'Clear' },

  g = {},

})
