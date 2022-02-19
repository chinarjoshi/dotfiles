require('plugins.packer').startup(function()
  for _, plugin in ipairs({
  -------------------------------- Base
  { 'wbthomason/packer.nvim', event = 'VimEnter', },
  { 'nvim-treesitter/nvim-treesitter', run=':TSUpdate'},
  { 'kyazdani42/nvim-tree.lua', after = 'nvim-web-devicons', },
  { 'nvim-telescope/telescope.nvim', module = 'telescope', cmd = 'Telescope', },
  { 'ahmedkhalf/project.nvim', config = function() require('project_nvim').setup() end },
  { 'lewis6991/impatient.nvim' },
  { 'nvim-lua/plenary.nvim' },
  { 'nathom/filetype.nvim' },

 -------------------------------- LSP,
  { 'neovim/nvim-lspconfig', module = 'lspconfig' },
  { 'ray-x/lsp_signature.nvim', after = 'nvim-lspconfig', },
  { 'folke/lsp-colors.nvim', after = 'nvim-lspconfig' },
  { 'williamboman/nvim-lsp-installer' },
  { 'folke/trouble.nvim', cmd = { 'Trouble', 'TroubleToggle' }, config = function() require('trouble').setup() end },
  { 'kosayoda/nvim-lightbulb', after = 'nvim-lspconfig' },
  { 'liuchengxu/vista.vim', cmd = 'Vista' },
  { 'onsails/lspkind-nvim', after = 'nvim-cmp' },

  -------------------------------- Completion,
  { 'hrsh7th/nvim-cmp', after = 'friendly-snippets', },
  { 'hrsh7th/cmp-nvim-lua', after = 'cmp_luasnip', },
  { 'hrsh7th/cmp-nvim-lsp', after = 'cmp-nvim-lua', },
  { 'hrsh7th/cmp-buffer', after = 'cmp-nvim-lsp', },
  { 'hrsh7th/cmp-path', after = 'cmp-buffer', },
  { 'saadparwaiz1/cmp_luasnip', after = 'LuaSnip', },

  --------------------------------- Snippets,
  { 'L3MON4D3/LuaSnip', after = 'nvim-cmp', },
  { 'rafamadriz/friendly-snippets', module = 'cmp_nvim_lsp', event = 'InsertCharPre', },

  --------------------------------- Git,
  { 'lewis6991/gitsigns.nvim', opt = true, },
  { 'TimUntersberger/neogit', cmd = 'Neogit', config = function() require('neogit').setup() end },

  --------------------------------- Editing,
  { 'ggandor/lightspeed.nvim', event = 'BufRead' },
  { 'tpope/vim-surround', event = 'BufRead' },
  { 'tpope/vim-commentary', event = 'BufRead' },
  { 'folke/todo-comments.nvim', event = 'BufRead', config = function() require('todo-comments').setup() end },

  --------------------------------- Aesthetic,
  { 'NvChad/nvim-base16.lua',
     after = 'packer.nvim',
     config = function()
       local base16 = require('base16')
       base16(base16.themes('onedark'), true)
       package.loaded['core.highlights' or false] = nil
       require 'core.highlights'
     end
  },
  { 'feline-nvim/feline.nvim', after = 'nvim-web-devicons', },
  { 'kyazdani42/nvim-web-devicons', after = 'nvim-base16.lua'},
  { 'NvChad/nvim-colorizer.lua', event = 'BufRead', },
  { 'akinsho/bufferline.nvim', after = 'nvim-web-devicons' },

  --------------------------------- Etc.
  { 'nvim-orgmode/orgmode', ft = 'org', require = 'akinsho/org-bullets.nvim' },
  { 'folke/which-key.nvim' },
  { 'lukas-reineke/indent-blankline.nvim', event = 'BufRead', },
  { 'ellisonleao/glow.nvim', cmd = 'Glow' },
  { 'mizlan/iswap.nvim', cmd = { 'ISwap', 'ISwapWith' } },
  { 'andymass/vim-matchup', opt = true, },
  { 'windwp/nvim-autopairs', after = 'nvim-cmp' },
}) do
    use(plugin)
  end
end)
