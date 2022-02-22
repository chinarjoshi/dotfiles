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
    c = {'TroubleToggle', 'Trouble'},
    d = {'lua vim.lsp.diagnostic.show_line_diagnostics()', 'Diagnostic'},
    D = {'lua vim.lsp.buf.type_definition()', 'Definition'},
    i = {'lua vim.lsp.buf.implementation()', 'Implementation'},
    s = {'lua vim.lsp.buf.signature_help()', 'Signature help'},
    n = {'lua vim.lsp.diagnostic.goto_next()', 'Signature help'},
    p = {'lua vim.lsp.diagnostic.goto_prev()', 'Signature help'},
    r = {'lua vim.lsp.buf.references()', 'References'},

  },
}
map('gd', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>')
map('gD', '<cmd>lua vim.lsp.buf.definition()<CR>')
map('K', '<cmd>lua vim.lsp.buf.hover()<CR>')
map('gi', '<cmd>lua vim.lsp.buf.implementation()<CR>')
map('gn', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>')
map('gp', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>')
  -- buf_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)

  -- buf_set_keymap('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
  -- buf_set_keymap('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
  -- buf_set_keymap('n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
  -- buf_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
  -- buf_set_keymap('n', '<space>ci', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
  -- buf_set_keymap('n', '<space>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
  -- buf_set_keymap('n', '<space>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
  -- buf_set_keymap('n', '<space>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
  -- buf_set_keymap('n', '<space>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
  -- buf_set_keymap('n', '<space>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
  -- buf_set_keymap('n', '<space>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
  -- buf_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
  -- buf_set_keymap('n', '<space>cd', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>', opts)
  -- buf_set_keymap('n', '[d', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', opts)
  -- buf_set_keymap('n', ']d', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>', opts)
  -- buf_set_keymap('n', '<space>cl', '<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>', opts)
  -- buf_set_keymap('n', '<space>cf', '<cmd>lua vim.lsp.buf.formatting()<CR>', opts)

key.setup {
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
