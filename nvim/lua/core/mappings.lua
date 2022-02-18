require('which-key').register({
  q = {'<cmd>wqa<cr>', 'Quit'},
  Q = {'<cmd>qa!<cr>', 'Force Quit'},
  f = {
    name = 'File',
    f = {'<cmd>Telescope<cr>', 'Find'},
    s = {'<cmd>w<cr>', 'Save'},
    t = {'<cmd>NvimTreeToggle<cr>', 'Tree'},
  },
  n = {
    name = 'Notes',
  },
  s = {
    name = 'Search',
  },
  t = {'<cmd>Term<cr>', 'Terminal'},
  p = {'<cmd>Telescope projects<cr>', 'Project'},
  c = {'<cmd>noh<cr>', 'Clear'},
  g = {'<cmd>Neogit<cr>', 'Git'},
  b = {
    name = 'Buffer',
    d = {'<cmd>bd<cr>', 'Delete'},
    n = {'<cmd>bn<cr>', 'Next' },
    p = {'<cmd>bp<cr>', 'Previous' },
  },
  w = {
    name = 'Window',
  },
}, { prefix = '<leader>' })
