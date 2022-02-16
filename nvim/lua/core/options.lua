-----------------------------------------------------------
-- Settings
-----------------------------------------------------------

for key, option in pairs({
   cul = true,
   clipboard = "unnamedplus",
   title = true,
   hidden = true,
   ignorecase = true,
   smartcase = true,
   mouse = "a",
   number = true,
   numberwidth = 2,
   expandtab = true,
   shiftwidth = 4,
   smartindent = true,
   tabstop = 4,
   timeoutlen = 400,
   undofile = true,
   fillchars = { eob = " " },
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
    vim.opt[key] = option
end

vim.opt.shortmess:append "sI"
vim.opt.whichwrap:append "<>[]hl"
vim.g.mapleader = ' '

-- disable some builtin vim plugins
for _, plugin in ipairs({
   "2html_plugin",
   "getscript",
   "getscriptPlugin",
   "gzip",
   "logipat",
   "netrw",
   "netrwPlugin",
   "netrwSettings",
   "netrwFileHandlers",
   "matchit",
   "tar",
   "tarPlugin",
   "rrhelper",
   "spellfile_plugin",
   "vimball",
   "vimballPlugin",
   "zip",
   "zipPlugin",
}) do
   vim.g["loaded_" .. plugin] = 1
end

