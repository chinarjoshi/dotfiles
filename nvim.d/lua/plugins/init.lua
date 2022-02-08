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
   { "nvim-lua/plenary.nvim" },
   { "lewis6991/impatient.nvim" },
   { "nathom/filetype.nvim" },
   {
      "wbthomason/packer.nvim",
      event = "VimEnter",
   },
   {
      "NvChad/nvim-base16.lua",
      after = "packer.nvim",
      config = function()
         require("colors").init()
      end,
   },
   {
      "kyazdani42/nvim-web-devicons",
      after = "nvim-base16.lua",
   },
   {
      "feline-nvim/feline.nvim",
      after = "nvim-web-devicons",
   },
   {
      "akinsho/bufferline.nvim",
      after = "nvim-web-devicons",
      setup = function()
         require("core.mappings").bufferline()
      end,
   },
   {
      "lukas-reineke/indent-blankline.nvim",
      event = "BufRead",
   },

   {
      "NvChad/nvim-colorizer.lua",
      event = "BufRead",
   },

   {
      "nvim-treesitter/nvim-treesitter",
      event = "BufRead",
   },

   -- git stuff
   {
      "lewis6991/gitsigns.nvim",
      setup = function()
         require("core.utils").packer_lazy_load "gitsigns.nvim"
      end,
   },

   -- lsp stuff

   {
      "neovim/nvim-lspconfig",
      module = "lspconfig",
      setup = function()
         require("core.utils").packer_lazy_load "nvim-lspconfig"
         -- reload the current file so lsp actually starts for it
         vim.defer_fn(function()
            vim.cmd 'if &ft == "packer" | echo "" | else | silent! e %'
         end, 0)
      end,
   },

   {
      "ray-x/lsp_signature.nvim",
      after = "nvim-lspconfig",
   },

   {
      "andymass/vim-matchup",
      setup = function()
         require("core.utils").packer_lazy_load "vim-matchup"
      end,
   },

   {
      "max397574/better-escape.nvim",
      event = "InsertEnter",
   },

   -- load luasnips + cmp related in insert mode only

   {
      "rafamadriz/friendly-snippets",
      module = "cmp_nvim_lsp",
      event = "InsertEnter",
   },

   -- cmp by default loads after friendly snippets
   -- if snippets are disabled -> cmp loads on insertEnter!
   {
      "hrsh7th/nvim-cmp",
      event = not plugin_settings.status.snippets and "InsertEnter",
      after = plugin_settings.status.snippets and "friendly-snippets",
   },

   {
      "L3MON4D3/LuaSnip",
      wants = "friendly-snippets",
      after = "nvim-cmp",
   },

   {
      "saadparwaiz1/cmp_luasnip",
      after = plugin_settings.options.cmp.lazy_load and "LuaSnip",
   },

   {
      "hrsh7th/cmp-nvim-lua",
      after = (plugin_settings.status.snippets and "cmp_luasnip") or "nvim-cmp",
   },

   {
      "hrsh7th/cmp-nvim-lsp",
      after = "cmp-nvim-lua",
   },

   {
      "hrsh7th/cmp-buffer",
      after = "cmp-nvim-lsp",
   },

   {
      "hrsh7th/cmp-path",
      after = "cmp-buffer",
   },

   -- misc plugins
   {
      "windwp/nvim-autopairs",
      after = 'nvim-cmp'
   },

   -- file managing , picker etc
   {
      "kyazdani42/nvim-tree.lua",
      -- only set "after" if lazy load is disabled and vice versa for "cmd"
      after = not true and "nvim-web-devicons",
      cmd = true and { "NvimTreeToggle", "NvimTreeFocus" },
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
}

return packer.startup { plugins }
