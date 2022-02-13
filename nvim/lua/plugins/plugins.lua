-----------------------------------------------------------
-- Plugin manager configuration file
-----------------------------------------------------------

local install_path = vim.fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
  packer_bootstrap = vim.fn.system({'git', 'clone', 'https://github.com/wbthomason/packer.nvim', install_path})
end
local packer = require 'packer'
vim.cmd [[packadd packer.nvim]]
vim.cmd [[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost plugins.lua source <afile> | PackerSync
  augroup end
]]

packer.init {
  display = {
    open_fn = function()
      return require('packer.util').float { border = 'rounded' }
    end,
  },
}

return packer.startup(function()
  config = {
    compile_path = vim.fn.stdpath('config')..'/lua/packer_compiled.lua'
  },
  -------------------------------- Base
  use { 'wbthomason/packer.nvim', event = 'VimEnter', }
  use { 'nvim-treesitter/nvim-treesitter', event = 'BufRead', run=':TSUpdate'},
  use 'lewis6991/impatient.nvim'
  use 'nvim-lua/plenary.nvim'
  use { 'kyazdani42/nvim-tree.lua',
     after = 'nvim-web-devicons', --cmd = { 'NvimTreeToggle', 'NvimTreeFocus' }, --if lazyload
     setup = function()
        require('core.mappings').nvimtree()
     end,
  }
  use { 'nvim-telescope/telescope.nvim',
     module = 'telescope',
     cmd = 'Telescope',
     setup = function()
        require('core.mappings').telescope()
     end,
  }
  use 'ahmedkhalf/project.nvim'
  use 'nathom/filetype.nvim'

 -------------------------------- LSP
  use { 'neovim/nvim-lspconfig',
     module = 'lspconfig',
     setup = function()
        require('core.utils').packer_lazy_load 'nvim-lspconfig'
        vim.defer_fn(function()
           vim.cmd 'if &ft == 'packer' | echo '' | else | silent! e %'
        end, 0)
     end,
  }
  use { 'ray-x/lsp_signature.nvim', after = 'nvim-lspconfig', }
  use 'folke/lsp-colors.nvim'
  use 'folke/trouble.nvim'
  use 'kosayoda/nvim-lightbulb'
  use 'liuchengxu/vista.vim'
  use 'onsails/lspkind'

  -------------------------------- Completion
  use { 'hrsh7th/nvim-cmp', after = 'friendly-snippets', }
  use { 'hrsh7th/cmp-nvim-lsp', after = 'cmp-nvim-lua', }
  use { 'hrsh7th/cmp-nvim-lua', after = 'cmp_luasnip' or 'nvim-cmp', }
  use { 'hrsh7th/cmp-buffer', after = 'cmp-nvim-lsp', }
  use { 'hrsh7th/cmp-path', after = 'cmp-buffer', }
  use { 'saadparwaiz1/cmp_luasnip', after = 'LuaSnip', }

  --------------------------------- Snippets
  use { 'L3MON4D3/LuaSnip',
     after = 'nvim-cmp',
  }
  use { 'rafamadriz/friendly-snippets',
     module = 'cmp_nvim_lsp',
     event = 'InsertEnter',
  }

  --------------------------------- Git
  use { 'lewis6991/gitsigns.nvim',
     setup = function()
        require('core.utils').packer_lazy_load 'gitsigns.nvim'
     end,
  }
  use 'TimUntersberger/neogit'

  --------------------------------- Editing
  use 'ggandor/lightspeed.nvim'
  use 'windwp/nvim-autopairs'
  use 'tpope/vim-surround'
  use 'tpope/vim-commentary'
  use 'folke/todo-comments.nvim'

  --------------------------------- Aesthetic
  use { 'NvChad/nvim-base16.lua',
     after = 'packer.nvim',
     config = function()
        require('colors').init()
     end,
  }
  use { 'feline-nvim/feline.nvim', after = 'nvim-web-devicons', }
  use { 'kyazdani42/nvim-web-devicons', after = 'nvim-base16.lua'}
  use { 'NvChad/nvim-colorizer.lua', event = 'BufRead', }
  use { 'yamatsum/nvim-cursorline' }
  use { 'akinsho/bufferline.nvim',
     after = 'nvim-web-devicons',
     setup = function()
        require('core.mappings').bufferline()
     end,
  }

  --------------------------------- Etc.
  use { 'nvim-orgmode/orgmode', ft = 'org' }
  use 'folke/which-key.nvim'
  use { 'lukas-reineke/indent-blankline.nvim', event = 'BufRead', }
  use 'ellisonleao/glow.nvim'
  use { 'mizlan/iswap.nvim', cmd = { 'ISwap', 'ISwapWith' } }
  use { 'andymass/vim-matchup',
     setup = function()
        require('core.utils').packer_lazy_load 'vim-matchup'
     end,
  }
  use { 'windwp/nvim-autopairs', after = 'nvim-cmp' }

end)