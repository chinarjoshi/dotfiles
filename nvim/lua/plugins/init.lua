require('plugins.packer').startup(function()
  for _, plugin in ipairs({
  -------------------------------- Base
  { 'wbthomason/packer.nvim', event = 'VimEnter', },
  { 'nvim-treesitter/nvim-treesitter', run=':TSUpdate'},
  { 'kyazdani42/nvim-tree.lua', after = 'nvim-web-devicons', },
  { 'nvim-telescope/telescope.nvim', module = 'telescope', cmd = 'Telescope', },
  { 'ahmedkhalf/project.nvim', after = 'telescope.nvim' },
  { 'nvim-lua/plenary.nvim', module = 'plenary' },
  { 'folke/which-key.nvim', module = 'which-key' },
  { 'lewis6991/impatient.nvim' },
  { 'nathom/filetype.nvim' },

 -------------------------------- LSP,
  { 'neovim/nvim-lspconfig', module = 'lspconfig' },
  { 'ray-x/lsp_signature.nvim', after = 'nvim-lspconfig', },
  { 'folke/lsp-colors.nvim', after = 'nvim-lspconfig' },
  { 'williamboman/nvim-lsp-installer', module = 'nvim-lsp-installer' },
  { 'folke/trouble.nvim', cmd = { 'Trouble', 'TroubleToggle' } },
  { 'onsails/lspkind-nvim', after = 'nvim-cmp' },
  { 'jose-elias-alvarez/null-ls.nvim', after = 'nvim-cmp' },

  -------------------------------- Completion,
  { 'hrsh7th/nvim-cmp', after = 'friendly-snippets', },
  { 'hrsh7th/cmp-nvim-lua', after = 'cmp_luasnip', },
  { 'hrsh7th/cmp-nvim-lsp', after = 'cmp-nvim-lua', },
  { 'hrsh7th/cmp-buffer', after = 'cmp-nvim-lsp', },
  { 'hrsh7th/cmp-path', after = 'cmp-buffer', },
  { 'saadparwaiz1/cmp_luasnip', after = 'LuaSnip', },

  --------------------------------- Snippets,
  { 'L3MON4D3/LuaSnip', after = 'nvim-cmp', },
  { 'rafamadriz/friendly-snippets', module = 'cmp_nvim_lsp', event = 'BufRead', },
  { 'michaelb/sniprun', cmd = 'SnipRun' },

  --------------------------------- Git,
  { 'lewis6991/gitsigns.nvim', opt = true, },
  { 'TimUntersberger/neogit', cmd = 'Neogit' },

  --------------------------------- Editing,
  { 'ggandor/lightspeed.nvim', event = 'BufRead' },
  { 'tpope/vim-surround', event = 'BufRead' },
  { 'tpope/vim-commentary', event = 'BufRead' },
  { 'tpope/vim-repeat', event = 'BufRead' },
  { 'wellle/targets.vim', event = 'BufRead'},
  { 'folke/todo-comments.nvim', module = 'todo-comments' },
  { 'mfussenegger/nvim-lint', module = 'lint' },

  --------------------------------- Windows and Splits,
  { 'beauwilliams/focus.nvim', module = 'focus' },
  { 'luukvbaal/stabilize.nvim', event = 'BufRead' },
  { 'sindrets/winshift.nvim', cmd = 'WinShift' },
  { 'https://gitlab.com/yorickpeterse/nvim-window.git', module = 'nvim-window' },

  --------------------------------- Aesthetic,
  { 'NvChad/nvim-base16.lua', after = 'packer.nvim' },
  { 'feline-nvim/feline.nvim', after = 'nvim-web-devicons', },
  { 'kyazdani42/nvim-web-devicons', after = 'nvim-base16.lua'},
  { 'NvChad/nvim-colorizer.lua', event = 'BufRead', },
  { 'akinsho/bufferline.nvim', after = 'nvim-web-devicons' },

  --------------------------------- Etc.
  { 'nvim-orgmode/orgmode', ft = 'org', require = 'akinsho/org-bullets.nvim' },
  { 'lukas-reineke/indent-blankline.nvim', event = 'BufRead', },
  { 'liuchengxu/vista.vim', cmd = 'Vista' },
  { 'ellisonleao/glow.nvim', cmd = 'Glow' },
  { 'mizlan/iswap.nvim', cmd = { 'ISwap', 'ISwapWith' } },
  { 'akinsho/toggleterm.nvim' },
  { 'andymass/vim-matchup', opt = true, },
  { 'windwp/nvim-autopairs', after = 'nvim-cmp' },
}) do
    use(plugin)
  end
end)
