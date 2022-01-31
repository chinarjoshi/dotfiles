-----------------------------------------------------------
-- Plugin manager configuration file
-----------------------------------------------------------

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
      return require("packer.util").float { border = "rounded" }
    end,
  },
}
return packer.startup(function()
  config = {
    compile_path = vim.fn.stdpath('config')..'/lua/packer_compiled.lua'
  }
  -------------------------------- Base
  use 'wbthomason/packer.nvim'
  use {'nvim-treesitter/nvim-treesitter', run=':TSUpdate'}
  use 'lewis6991/impatient.nvim'
  use 'nvim-lua/plenary.nvim'
  use 'kyazdani42/nvim-tree.lua'
  use 'nvim-telescope/telescope.nvim'
  use "ahmedkhalf/project.nvim"

  -------------------------------- LSP
  use 'neovim/nvim-lspconfig'
  use 'nvim-lua/lsp-status.nvim'
  use 'folke/lsp-colors.nvim'
  use 'folke/trouble.nvim'
  use 'kosayoda/nvim-lightbulb'
  use 'liuchengxu/vista.vim'

  -------------------------------- Completion
  use 'hrsh7th/nvim-cmp'
  use 'hrsh7th/cmp-nvim-lsp'
  use 'hrsh7th/cmp-buffer'
  use 'hrsh7th/cmp-path'
  use 'hrsh7th/cmp-cmdline'
  use 'saadparwaiz1/cmp_luasnip'

  --------------------------------- Snippets
  use 'L3MON4D3/LuaSnip'
  use 'rafamadriz/friendly-snippets'

  --------------------------------- Git
  use 'TimUntersberger/neogit'
  use 'lewis6991/gitsigns.nvim'

  --------------------------------- Editing
  use 'ggandor/lightspeed.nvim'
  use 'blackCauldron7/surround.nvim'
  use 'windwp/nvim-autopairs'
  use 'windwp/nvim-ts-autotag'
  use 'numToStr/Comment.nvim'
  use 'folke/todo-comments.nvim'

  --------------------------------- Aesthetic
  use 'navarasu/onedark.nvim'
  use 'kyazdani42/nvim-web-devicons'
  use 'nvim-lualine/lualine.nvim'

  --------------------------------- Etc.
  use 'nvim-orgmode/orgmode'
  use 'folke/which-key.nvim'
  use 'lukas-reineke/indent-blankline.nvim'
  use 'ellisonleao/glow.nvim'

end)
