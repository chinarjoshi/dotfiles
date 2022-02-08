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

local plugins = {
   config = {
     compile_path = vim.fn.stdpath('config')..'/lua/packer_compiled.lua'
   },
   -------------------------------- Base
   { "wbthomason/packer.nvim", event = "VimEnter", },
   { "nvim-treesitter/nvim-treesitter", event = "BufRead", run=':TSUpdate'},
   { "lewis6991/impatient.nvim" },
   { "nvim-lua/plenary.nvim" },
   {
      "kyazdani42/nvim-tree.lua",
      after = "nvim-web-devicons", -- if not lazyload
      --cmd = { "NvimTreeToggle", "NvimTreeFocus" }, --if lazyload
      setup = function()
         require("core.mappings").nvimtree()
      end,
   },
   {
      "nvim-telescope/telescope.nvim",
      module = "telescope",
      cmd = "Telescope",
      setup = function()
         require("core.mappings").telescope()
      end,
   },
   { 'ahmedkhalf/project.nvim' },
   {
      "neovim/nvim-lspconfig",
      module = "lspconfig",
      setup = function()
         require("core.utils").packer_lazy_load "nvim-lspconfig"
         vim.defer_fn(function()
            vim.cmd 'if &ft == "packer" | echo "" | else | silent! e %'
         end, 0)
      end,
   },
   { 'folke/trouble.nvim' },
   { 'kosayoda/nvim-lightbulb' },
   { 'liuchengxu/vista.vim' },
   { 'onsails/lspkind' },
   { "nathom/filetype.nvim" },
   {
      "NvChad/nvim-base16.lua",
      after = "packer.nvim",
      config = function()
         require("colors").init()
      end,
   },
   { "kyazdani42/nvim-web-devicons", after = "nvim-base16.lua", },
   { "feline-nvim/feline.nvim", after = "nvim-web-devicons", },
   {
      "akinsho/bufferline.nvim",
      after = "nvim-web-devicons",
      setup = function()
         require("core.mappings").bufferline()
      end,
   },
   { "lukas-reineke/indent-blankline.nvim", event = "BufRead", },

   { "NvChad/nvim-colorizer.lua", event = "BufRead", },


   -- git stuff
   {
      "lewis6991/gitsigns.nvim",
      setup = function()
         require("core.utils").packer_lazy_load "gitsigns.nvim"
      end,
   },

   -- lsp stuff


   { "ray-x/lsp_signature.nvim", after = "nvim-lspconfig", },

   {
      "andymass/vim-matchup",
      setup = function()
         require("core.utils").packer_lazy_load "vim-matchup"
      end,
   },

   -- load luasnips + cmp related in insert mode only

   {
      "rafamadriz/friendly-snippets",
      module = "cmp_nvim_lsp",
      event = "InsertEnter",
   },

   { "hrsh7th/nvim-cmp", after = "friendly-snippets", },

   {
      "L3MON4D3/LuaSnip",
      wants = "friendly-snippets",
      after = "nvim-cmp",
   },

   { "saadparwaiz1/cmp_luasnip", after = "LuaSnip", },

   { "hrsh7th/cmp-nvim-lua", after = 'cmp_luasnip' or "nvim-cmp", },

   { "hrsh7th/cmp-nvim-lsp", after = "cmp-nvim-lua", },

   { "hrsh7th/cmp-buffer", after = "cmp-nvim-lsp", },

   { "hrsh7th/cmp-path", after = "cmp-buffer", },

   -- misc plugins
   { "windwp/nvim-autopairs", after = 'nvim-cmp' },


}

return packer.startup { plugins }
