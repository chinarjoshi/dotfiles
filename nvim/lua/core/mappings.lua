local key = require('which-key')

local function map(key, command)
  vim.api.nvim_set_keymap('n', key, command, { noremap = true, silent = true })
end

local function rep(table)
  if type(table[1]) == 'string' then
    if string.find(table[1], 'Telescope') then
      table[1] = table[1] .. ' theme=ivy'
    end
    table[1] = '<cmd>' .. table[1] .. '<cr>'
  elseif type(table) == 'table' then
    for _, v in pairs(table) do
      rep(v)
    end
  end
end

require('which-key').setup {
  ignore_missing = true,
  window = {
    margin = { 0, 0, 0, 0 }, -- margin [top, right, bottom, left]
    padding = { 0, 0, 0, 0 }, -- padding [top, right, bottom, left]
    winblend = 0,
    border = 'single'
  },
  layout = {
    height = { min = 1, max = 25 }, -- min and max height of the columns
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

local mappings = {
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
    o = {'Telescope oldfiles', 'Opened files'},
  },
  -- TODO: Org notes
  n = { name = 'notes',
  },
  -- Search
  s = { name = 'search',
    s = {'Telescope current_buffer_fuzzy_find', 'Current buffer'},
    t = {'TodoTelescope', 'TODOs'},
    v = {'Vista', 'Vista'},
  },
  -- Open terminal
  t = {'Term', 'Terminal'},
  r = {'SnipRun', 'Run snippet'},
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
    w = { "lua require'nvim-window'.pick()", 'Pick' },
    W = { "WinShift swap", 'Swap' },
    c = { "wincmd c", 'Delete' },
    s = { "wincmd s", 'Hori split' },
    v = { "wincmd v", 'Vert split' },
    h = { "wincmd h", 'Left' },
    j = { "wincmd j", 'Down' },
    k = { "wincmd k", 'Up' },
    l = { "wincmd l", 'Right' },
    H = { "WinShift left", 'Shift left' },
    J = { "WinShift down", 'Shift down' },
    K = { "WinShift up", 'Shift down' },
    L = { "WinShift right", 'Shift down' },
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
key.register(mappings, { prefix = '<leader>' })
key.register({r = {'SnipRun', 'Run snippet'}}, { mode = 'v', prefix = '<leader>' })

for _, dir in ipairs({'up', 'down', 'left', 'right'}) do
  map('<'..dir..'>', '<cmd>WinShift '.. dir ..'<cr>')
end
map('<C-h>', '<C-w>h')
map('<C-j>', '<C-w>j')
map('<C-k>', '<C-w>k')
map('<C-l>', '<C-w>l')
vim.cmd('nnoremap ; :')
vim.cmd('nnoremap : ;')
