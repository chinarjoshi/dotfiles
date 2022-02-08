-----------------------------------------------------------
-- Neovim settings
-----------------------------------------------------------

for _, option in ipairs({
   cul = true,
   clipboard = "unnamedplus",
   title = true,
   hidden = true,
   ignorecase = true,
   smartcase = true,
   mapleader = " ",
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
    vim.opt.option = option
end

vim.opt.shortmess:append "sI"
vim.opt.whichwrap:append "<>[]hl"
vim.g.mapleader = options.mapleader

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
   g["loaded_" .. plugin] = 1
end

plugins = {
   -- enable/disable plugins (false for disable)
   status = {
      blankline = true, -- indentline stuff
      bufferline = true, -- manage and preview opened buffers
      colorizer = false, -- color RGB, HEX, CSS, NAME color codes
      comment = true, -- easily (un)comment code, language aware
      dashboard = false,
      better_escape = true, -- map to <ESC> with no lag
      feline = true, -- statusline
      gitsigns = true,
      lspsignature = true, -- lsp enhancements
      vim_matchup = true, -- improved matchit
      cmp = true,
      snippets = true,
      nvimtree = true,
      autopairs = true,
   },
   options = {
      packer = {
         init_file = "plugins.packerInit",
      },
      autopairs = { loadAfter = "nvim-cmp" },
      cmp = {
         lazy_load = true,
      },
      lspconfig = {
         setup_lspconf = "", -- path of file containing setups of different lsps
      },
      nvimtree = {
         -- packerCompile required after changing lazy_load
         lazy_load = true,
      },
      luasnip = {
         snippet_path = {},
      },
      statusline = {
         -- hide, show on specific filetypes
         hidden = {
            "help",
            "dashboard",
            "NvimTree",
            "terminal",
         },
         shown = {},

         -- truncate statusline on small screens
         shortline = true,
         style = "default", -- default, round , slant , block , arrow
      },
      esc_insertmode_timeout = 300,
   },
   default_plugin_config_replace = {},
   default_plugin_remove = {},
   install = nil,
}
