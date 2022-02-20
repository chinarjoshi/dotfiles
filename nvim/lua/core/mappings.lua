local map = vim.api.nvim_set_keymap
local default_opts = { noremap = true, silent = true }

function rep(table)
  if type(table[1]) == 'string' then
    table[1] = '<cmd>' .. table[1] .. '<cr>'
  elseif type(table) == 'table' then
    for _, v in pairs(table) do
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
  ['\\'] = {'noh', 'Clear search'},
  -- Quitting
  q = { name = 'quit',
    q = {'wqa', 'Quit'},
    f = {'qa!', 'Force quit'},
    r = {'Restart'},
  },
  -- Files
  f = { name = 'file',
    f = {'Telescope find_files', 'Find'},
    s = {'w', 'Save'},
    p = {'Telescope projects', 'Projects'},
    t = {'NvimTreeToggle', 'Tree'},
    c = {'y+', 'Copy file'},
  },
  -- TODO: Org notes
  n = { name = 'notes',
  },
  -- Search
  s = { name = 'search',
    s = {'TodoTelescope', 'TODOs'},
    t = {'Vista', 'Tags'},
  },
  -- Open terminal
  t = {'Term', 'Terminal'},
  -- Plugin manager
  p = { name = 'plugins',
    p = {'PackerSync', 'Sync'},
    s = {'PackerStatus', 'Status'},
    c = {'PackerCompile', 'Compile'},
    r = {'PackerProfile', 'Profile'},
    u = {'PackerUpdate', 'Update'},
    i = {'PackerInstall', 'Install'},
    l = {'PackerClean', 'Clean'},
  },
  g = { name = 'git',
    g = {'Neogit', 'Magit'},
    c = {'Telescope git_commits', 'Commits'},
    b = {'Telescope git_branches', 'Branches'},
    s = {'Telescope git_status', 'Status'},
    t = {'Telescope git_stash', 'Stash'},
    f = {'Telescope git_bcommits', 'Commits in current file'},
  },
  -- Buffers
  b = { name = 'buffer',
    b = {'Telescope buffers', 'Pick buffer'},
    d = {'bd', 'Delete'},
    n = {'bn', 'Next' },
    p = {'bp', 'Previous' },
  },
  -- Windows
  w = { name = 'window',
  },
  -- Tag viewer
  c = { name = 'code',
    d = {'diagnostic'},
    h = {'hover'},
    i = {'impl'},
    s = {'sig'},
  },
}

rep(mappings)
require('which-key').register(mappings, { prefix = '<leader>' })
