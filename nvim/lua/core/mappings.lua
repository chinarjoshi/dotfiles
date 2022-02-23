local ok, key = pcall(require, 'which-key')
if not ok then
    return
end

local mappings = {
  -- Hotkeys
  ['<space>'] = {'Telescope git_files theme=ivy layout_config={height=15}', 'Find file in project'},
  ['<tab>'] = {'Telescope projects theme=ivy layout_config={height=15}', 'Projects'},
  ['/'] = {'Telescope live_grep theme=ivy layout_config={height=15}', 'Search project'},
  [','] = {'Telescope buffers theme=ivy layout_config={height=15}', 'Switch buffer'},
  ['.'] = {'Telescope find_files theme=ivy layout_config={height=15}', 'Find file'},
  ['*'] = {'Telescope grep_string theme=ivy layout_config={height=15}', 'Search word under cursor'},
  ['<cr>'] = {'ToggleTerm', 'Open terminal'},
  [';'] = {'NvimTreeToggle', 'File-tree'},
  ['\\'] = {'noh', 'Clear search'},
  ['-'] = {[[%s/\s\+$//e]], 'Clear whitespace'},
  -- Quitting
  q = { name = 'quit',
    q = {'wqa', 'Quit'},
    f = {'qa!', 'Force quit'},
    r = {'Restart'},
  },
  -- Files
  f = { name = 'file',
    f = {'Telescope find_files theme=ivy layout_config={height=15}', 'Find'},
    s = {'w', 'Save'},
    p = {'Telescope projects theme=ivy layout_config={height=15}', 'Projects'},
    t = {'NvimTreeToggle', 'Tree'},
    c = {'%y+', 'Copy file'},
    o = {'Telescope oldfiles theme=ivy layout_config={height=15}', 'Opened files'},
  },
  n = { name = 'notes',
  },
  -- Search
  s = { name = 'search',
    s = {'Telescope current_buffer_fuzzy_find theme=ivy layout_config={height=15}', 'Current buffer'},
    t = {'TodoTelescope theme=ivy preview=10', 'TODOs'},
    v = {'Vista', 'Vista'},
  },
  -- Open terminal
  t = {'ToggleTerm', 'Terminal'},
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
    c = {'Telescope git_commits preview=10', 'Commits'},
    b = {'Telescope git_branches preview=10', 'Branches'},
    s = {'Telescope git_status preview=10', 'Status'},
    t = {'Telescope git_stash preview=10', 'Stash'},
    f = {'Telescope git_bcommits preview=10', 'Commits in current file'},
  },
  -- Buffers
  b = { name = 'buffer',
    b = {'Telescope buffers theme=ivy layout_config={height=15}', 'Pick buffer'},
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
  -- Code actions
  c = { name = 'code',
    c = {'TroubleToggle document_diagnostics', 'Document diagnostics'},
    w = {'TroubleToggle workspace_diagnostics', 'Workspace diagnostics'},
    r = {'TroubleToggle lsp_references', 'References'},
    d = {'TroubleToggle lsp_definitions', 'Definitions'},
    t = {'TroubleToggle lsp_type_definitions', 'Type definitions'},
    a = {'Telescope lsp_code_actions theme=ivy layout_config={height=15}', 'Actions'},
  },
}

local lsp = {
    d = {'<cmd>lua vim.lsp.buf.definition()<CR>', 'Definition'},
    D = {'<cmd>lua vim.lsp.buf.declaration()<CR>', 'Declaration'},
    e = {'<cmd>lua vim.diagnostic.open_float(0, {scope="line"})<CR>', 'Diagnostic'},
    ['['] = {'<cmd>lua vim.diagnostic.goto_prev()<CR>', 'Previous diagnostic'},
    [']'] = {'<cmd>lua vim.diagnostic.goto_next()<CR>', 'Next diagnostic'},
    i = {'<cmd>lua vim.lsp.buf.implementation()<CR>', 'Implementaiton'},
    s = {'<cmd>lua vim.lsp.buf.signature_help()<CR>', 'Signature'},
    w = { name = 'workspace',
        a = {'<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', 'Add'},
        r = {'<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', 'Remove'},
        l = {'<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', 'List'},
    },
    t = {'<cmd>lua vim.lsp.buf.type_definition()<CR>', 'Type'},
    n = {'<cmd>lua vim.lsp.buf.rename()<CR>', 'Name'},
    a = {'<cmd>lua vim.lsp.buf.code_action()<CR>', 'Action'},
    r = {'<cmd>lua vim.lsp.buf.references()<CR>', 'References'},
    f = {'<cmd>lua vim.lsp.buf.formatting()<CR>', 'Format'},
}

local function rep(table)
  if type(table[1]) == 'string' then
    table[1] = '<cmd>' .. table[1] .. '<cr>'
  elseif type(table) == 'table' then
    for _, v in pairs(table) do
      rep(v)
    end
  end
end

rep(mappings)
key.register(mappings, { prefix = '<leader>' })
key.register(lsp, { prefix = 'g' })

local function map(key, command)
  vim.api.nvim_set_keymap('n', key, command, { noremap = true, silent = true })
end
map('K', '<cmd>lua vim.lsp.buf.hover()<CR>')
for _, dir in ipairs({'up', 'down', 'left', 'right'}) do
  map('<'..dir..'>', '<cmd>WinShift '.. dir ..'<cr>')
end
for _, letter in ipairs({'h', 'j', 'k', 'l'}) do
    map('<C-'..letter..'>', '<C-w>'..letter)
end
vim.cmd('nnoremap ; :')
vim.cmd('nnoremap : ;')
