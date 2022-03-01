local setup = require('core.utils').setup

require('plugins.packer').startup(function()
  for _, plugin in
    ipairs {
      -------------------------------- Base
      { 'wbthomason/packer.nvim', event = 'VimEnter' },
      { 'nvim-treesitter/nvim-treesitter', run = ':TSUpdate', config = setup 'treesitter' },
      { 'kyazdani42/nvim-tree.lua', cmd = { 'NvimTreeToggle', 'NvimTreeFocus' }, config = setup 'nvimtree' },
      { 'nvim-telescope/telescope.nvim', module = 'telescope', cmd = 'Telescope', config = setup 'telescope' },
      { 'ahmedkhalf/project.nvim', after = 'telescope.nvim', config = setup('project_nvim', true) },
      { 'folke/which-key.nvim', module = 'which-key', config = setup 'which-key' },
      { 'nvim-lua/plenary.nvim', module = 'plenary' },
      { 'lewis6991/impatient.nvim' },
      { 'nathom/filetype.nvim' },

      -------------------------------- LSP,
      { 'neovim/nvim-lspconfig', module = 'lspconfig', config = setup 'lspconfig' },
      { 'jose-elias-alvarez/null-ls.nvim', module = 'null-ls', config = setup 'null_ls' },
      { 'ray-x/lsp_signature.nvim', after = 'nvim-lspconfig', config = setup('lsp_signature', true) },
      { 'folke/lsp-colors.nvim', after = 'nvim-lspconfig' },
      { 'williamboman/nvim-lsp-installer', module = 'nvim-lsp-installer' },
      { 'folke/trouble.nvim', cmd = { 'Trouble', 'TroubleToggle' }, config = setup('trouble', true) },
      { 'onsails/lspkind-nvim', after = 'nvim-cmp' },

      -------------------------------- Completion,
      { 'hrsh7th/nvim-cmp', after = 'friendly-snippets', config = setup 'cmp' },
      { 'hrsh7th/cmp-nvim-lua', after = 'cmp_luasnip' },
      { 'hrsh7th/cmp-nvim-lsp', after = 'cmp-nvim-lua' },
      { 'hrsh7th/cmp-buffer', after = 'cmp-nvim-lsp' },
      { 'hrsh7th/cmp-path', after = 'cmp-buffer' },
      { 'saadparwaiz1/cmp_luasnip', after = 'LuaSnip' },

      --------------------------------- Snippets,
      { 'L3MON4D3/LuaSnip', after = 'nvim-cmp', config = setup('luasnip', true) },
      { 'rafamadriz/friendly-snippets', module = 'cmp_nvim_lsp', event = 'BufRead' },
      { 'michaelb/sniprun', cmd = 'SnipRun', config = setup('sniprun', true) },

      --------------------------------- Git,
      { 'lewis6991/gitsigns.nvim', opt = true, config = setup('gitsigns', true) },
      { 'TimUntersberger/neogit', cmd = 'Neogit', config = setup('neogit', true) },

      --------------------------------- Editing,
      { 'ggandor/lightspeed.nvim', event = 'BufRead' },
      { 'tpope/vim-surround', event = 'BufRead' },
      { 'tpope/vim-commentary', event = 'BufRead' },
      { 'tpope/vim-repeat', event = 'BufRead' },
      { 'wellle/targets.vim', event = 'BufRead' },
      { 'folke/todo-comments.nvim', module = 'todo-comments', config = setup('todo_comments', true) },

      --------------------------------- Windows and Splits,
      { 'luukvbaal/stabilize.nvim', event = 'BufRead', config = setup 'windows' },
      { 'https://gitlab.com/yorickpeterse/nvim-window.git', module = 'nvim-window' },
      { 'beauwilliams/focus.nvim', module = 'focus' },
      { 'sindrets/winshift.nvim', cmd = 'WinShift' },

      --------------------------------- Aesthetic,
      { 'NvChad/nvim-base16.lua', after = 'packer.nvim', config = setup 'colors' },
      { 'feline-nvim/feline.nvim', after = 'nvim-web-devicons', config = setup 'statusline' },
      { 'kyazdani42/nvim-web-devicons', after = 'nvim-base16.lua', config = setup 'icons' },
      { 'NvChad/nvim-colorizer.lua', event = 'BufRead' },

      --------------------------------- Etc.
      { 'windwp/nvim-autopairs', after = 'nvim-cmp', config = setup('nvim_autopairs', true) },
      { 'akinsho/toggleterm.nvim', cmd = 'ToggleTerm', config = setup('toggleterm', true) },
      { 'lukas-reineke/indent-blankline.nvim', event = 'BufRead', config = setup 'indent-blankline' },
      {
        'nvim-orgmode/orgmode',
        ft = 'org',
        require = 'akinsho/org-bullets.nvim',
        config = setup('orgmode', true),
      },
      { 'liuchengxu/vista.vim', cmd = 'Vista' },
      { 'ellisonleao/glow.nvim', cmd = 'Glow' },
      { 'mizlan/iswap.nvim', cmd = { 'ISwap', 'ISwapWith' } },
      { 'andymass/vim-matchup', opt = true },
    }
  do
    use(plugin)
  end
end)
