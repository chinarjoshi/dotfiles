require('plugins.packer').startup(function()
  config = {
    compile_path = vim.fn.stdpath('config')..'/lua/packer_compiled.lua'
  },
  -------------------------------- Base
  use { 'wbthomason/packer.nvim', event = 'VimEnter', }
  use { 'nvim-treesitter/nvim-treesitter', run=':TSUpdate'}
  use 'lewis6991/impatient.nvim'
  use 'nvim-lua/plenary.nvim'
  use { 'kyazdani42/nvim-tree.lua',
     after = 'nvim-web-devicons', --cmd = { 'NvimTreeToggle', 'NvimTreeFocus' }, --if lazyload
  }
  use { 'nvim-telescope/telescope.nvim',
     module = 'telescope',
     cmd = 'Telescope',
  }
  use 'ahmedkhalf/project.nvim'
  use 'nathom/filetype.nvim'

 -------------------------------- LSP
  use { 'neovim/nvim-lspconfig',
     module = 'lspconfig',
     opt = true,
     setup = function()
        require('core.utils').packer_lazy_load 'nvim-lspconfig'
        vim.defer_fn(function()
            vim.cmd 'if &ft == "packer" | echo "" | else | silent! e %'
        end, 0)
     end,
  }
  use { 'ray-x/lsp_signature.nvim', after = 'nvim-lspconfig', }
  use 'folke/lsp-colors.nvim'
  use 'folke/trouble.nvim'
  use 'kosayoda/nvim-lightbulb'
  use 'liuchengxu/vista.vim'
  use 'onsails/lspkind-nvim'

  -------------------------------- Completion
  use { 'hrsh7th/nvim-cmp', after = 'friendly-snippets', }
  use { 'hrsh7th/cmp-nvim-lua', after = 'cmp_luasnip', }
  use { 'hrsh7th/cmp-nvim-lsp', after = 'cmp-nvim-lua', }
  use { 'hrsh7th/cmp-buffer', after = 'cmp-nvim-lsp', }
  use { 'hrsh7th/cmp-path', after = 'cmp-buffer', }
  use { 'saadparwaiz1/cmp_luasnip', after = 'LuaSnip', }

  --------------------------------- Snippets
  use { 'L3MON4D3/LuaSnip',
     after = 'nvim-cmp',
  }
  use { 'rafamadriz/friendly-snippets',
     module = 'cmp_nvim_lsp',
     event = 'InsertCharPre',
  }

  --------------------------------- Git
  use { 'lewis6991/gitsigns.nvim',
     opt = true,
     setup = function()
        require('core.utils').packer_lazy_load 'gitsigns.nvim'
     end,
  }
  use 'TimUntersberger/neogit'

  --------------------------------- Editing
  use 'ggandor/lightspeed.nvim'
  use 'tpope/vim-surround'
  use 'tpope/vim-commentary'
  use 'folke/todo-comments.nvim'

  --------------------------------- Aesthetic
  use { 'NvChad/nvim-base16.lua',
     after = 'packer.nvim',
     config = function()
       base16 = require('base16')
       base16(base16.themes('onedark'), true)
       package.loaded["core.highlights" or false] = nil
       require "core.highlights"
     end,
  }
  use { 'feline-nvim/feline.nvim', after = 'nvim-web-devicons', }
  use { 'kyazdani42/nvim-web-devicons', after = 'nvim-base16.lua'}
  use { 'NvChad/nvim-colorizer.lua', event = 'BufRead', }
  use { 'yamatsum/nvim-cursorline' }
  use { 'akinsho/bufferline.nvim', after = 'nvim-web-devicons' }

  --------------------------------- Etc.
  use { 'nvim-orgmode/orgmode', ft = 'org' }
  use 'folke/which-key.nvim'
  use { 'lukas-reineke/indent-blankline.nvim', event = 'BufRead', }
  use 'ellisonleao/glow.nvim'
  use { 'mizlan/iswap.nvim', cmd = { 'ISwap', 'ISwapWith' } }
  use { 'andymass/vim-matchup',
     opt = true,
     setup = function()
        require('core.utils').packer_lazy_load 'vim-matchup'
     end,
  }
  use { 'windwp/nvim-autopairs', after = 'nvim-cmp' }

end)
