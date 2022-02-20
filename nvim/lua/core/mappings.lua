function rep(table)
  if type(table[1]) == 'string' then
    table[1] = '<cmd>' .. table[1] .. '<cr>'
  elseif type(table) == 'table' then
    for k, v in pairs(table) do
      rep(v)
    end
  end
end

mappings = {
  -- Hotkeys
  ['<space>'] = {'Telescope git_files', 'Find file in project'},
  ['<cr>'] = {'Term', 'Open terminal'},
  ['<tab>'] = {'Telescope projects', 'Projects'},
  ['/'] = {'Telescope live_grep', 'Search project'},
  [','] = {'Telescope buffers', 'Switch buffer'},
  ['.'] = {'Telescope find_files', 'Find file'},
  ['*'] = {'Telescope grep_string', 'Search word under cursor'},
  [';'] = {'NvimTreeToggle', 'File-tree'},
  -- Quitting
  q = { name = 'Quit',
    q = {'wqa', 'Quit'},
    f = {'qa!', 'Force quit'},
    r = {'Restart'},
  },
  -- Files
  f = { name = 'File',
    f = {'Telescope find_files', 'Find'},
    s = {'w', 'Save'},
    p = {'Telescope projects', 'Projects'},
    t = {'NvimTreeToggle', 'Tree'},
    c = {'y+', 'Copy file'},
  },
  -- TODO: Org notes
  n = { name = 'Notes',
  },
  -- Search
  s = { name = 'Search',
    s = {'TodoTelescope', 'Search TODOs'},
  },
  -- Open terminal
  t = {'Term', 'Terminal'},
  -- Plugin manager
  p = {'Telescope projects', 'Project'},
  c = {'noh', 'Clear'},
  g = {'Neogit', 'Git'},
  -- Buffers
  b = { name = 'Buffer',
    d = {'bd', 'Delete'},
    n = {'bn', 'Next' },
    p = {'bp', 'Previous' },
  },
  -- Windows
  w = { name = 'window',
  },
  -- Tag viewer
  v = { ':Vista', 'Vista tags' },
  l = { name = 'LSP',
    d = {'diagnostic'},
    h = {'hover'},
    i = {'impl'},
    s = {'sig'},
  },
  c = { name = 'code'

  },
}

rep(mappings)
require('which-key').register(mappings, { prefix = '<leader>' })
