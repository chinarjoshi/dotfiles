-----------------------------------------------------------
-- Neovim settings
-----------------------------------------------------------

local cmd = vim.cmd
local exec = vim.api.nvim_exec
local fn = vim.fn
local g = vim.g
local opt = vim.opt

for _, option in ipairs({
   title = true
   history = 100
   lazyredraw = true
   synmaxcol = 240
   splitbelow = true
   splitright = true
   termguicolors = true
   clipboard = 'unnamedplus',
   hidden = true,
   ignorecase = true,
   showmatch = true,
   foldmethod = 'marker'
   smartcase = true,
   mapleader = ' ',
   mouse = 'a',
   number = true,
   numberwidth = 2,
   completeopt = 'menuone,noselect'
   expandtab = true,
   shiftwidth = 4,
   smartindent = true,
   tabstop = 4,
   linebreak = true
   undofile = true,
   fillchars = { eob = ' ' },
   swapfile = false
   shadafile = vim.opt.shadafile,
}) do
    opt.option = option
end

opt.shortmess:append 'sI'
opt.whichwrap:append '<>[]hl'
g.mapleader = options.mapleader

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


vim.opt.shadafile = 'NONE'
vim.schedule(function()
   vim.opt.shadafile = require('core.utils').load_config().options.shadafile
   vim.cmd [[ silent! rsh ]]
end)

cmd [[colorscheme onedark]]

-- highlight on yank
exec([[
  augroup YankHighlight
    autocmd!
    autocmd TextYankPost * silent! lua vim.highlight.on_yank{higroup="IncSearch", timeout=200}
  augroup end
]], false)

-- No line numbers in term
cmd [[ au TermOpen term://* setlocal nonumber norelativenumber | setfiletype terminal ]]

-- Don't show status line on certain windows
cmd [[ autocmd BufEnter,BufRead,BufWinEnter,FileType,WinEnter * lua require("core.utils").hide_statusline() ]]

-- Don't autocomment new lines
cmd [[au BufEnter * set fo-=c fo-=r fo-=o]]

-- remove line lenght marker for selected filetypes
cmd [[autocmd FileType text,markdown,html,xhtml,javascript setlocal cc=0]]

-- 2 spaces for selected filetypes
cmd [[
  autocmd FileType xml,html,xhtml,css,scss,javascript,lua,yaml setlocal shiftwidth=2 tabstop=2
]]

-- Remove whitespace on save
cmd [[au BufWritePre * :%s/\s\+$//e]]

-- Open a term with :Term
cmd [[command Term :botright vsplit term://$SHELL]]
