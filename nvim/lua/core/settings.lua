local opt = vim.opt
local cmd = vim.cmd
local g = vim.g

for key, option in pairs({
   cul = true,
   clipboard = 'unnamedplus',
   title = true,
   hidden = true,
   ignorecase = true,
   smartcase = true,
   mouse = 'a',
   number = true,
   numberwidth = 2,
   expandtab = true,
   shiftwidth = 4,
   smartindent = true,
   tabstop = 4,
   timeoutlen = 400,
   undofile = true,
   fillchars = { eob = ' ' },
   signcolumn = 'yes',
   splitbelow = true,
   splitright = true,
   termguicolors = true,
   swapfile = false,
   showmatch = true,
   foldmethod = 'marker',
   linebreak = true,
   history = 100,
   lazyredraw = true,
   shadafile = vim.opt.shadafile,
   synmaxcol = 240,
   completeopt = 'menuone,noselect',
}) do
    opt[key] = option
end

for _, module in ipairs({
  [[au BufWritePre * :%s/\s\+$//e]],
  "autocmd TextYankPost * silent! lua vim.highlight.on_yank{higroup='IncSearch', timeout=200}",
  "au BufEnter * set fo-=c fo-=r fo-=o",
  "autocmd FileType text,markdown,html,xhtml,javascript setlocal cc=0",
  "autocmd FileType xml,html,xhtml,css,scss,javascript,lua,yaml setlocal shiftwidth=2 tabstop=2",
  "command Term :botright vsplit term://$SHELL",
  "autocmd TermOpen * setlocal listchars= nonumber norelativenumber nocursorline",
  "autocmd TermOpen * startinsert",
  "autocmd BufLeave term://* stopinsert",
}) do
  cmd(module)
end

-- Defer loading shada until after startup_
opt.shadafile = 'NONE'
vim.schedule(function()
  opt.shadafile = vim.opt.shadafile
  cmd [[ silent! rsh ]]
end)
opt.shortmess:append 'sI'
opt.whichwrap:append '<>[]hl'
g.mapleader = ' '

-- disable some builtin vim plugins
for _, plugin in ipairs({
   '2html_plugin',
   'getscript',
   'getscriptPlugin',
   'gzip',
   'logipat',
   'netrw',
   'netrwPlugin',
   'netrwSettings',
   'netrwFileHandlers',
   'matchit',
   'tar',
   'tarPlugin',
   'rrhelper',
   'spellfile_plugin',
   'vimball',
   'vimballPlugin',
   'zip',
   'zipPlugin',
}) do
   g['loaded_' .. plugin] = 1
end
