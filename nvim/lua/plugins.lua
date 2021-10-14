return require('packer').startup(function()
  local use = use
  use 'wbthomason/packer.nvim'

  -- prettiness
  use 'nvim-treesitter/nvim-treesitter'
  use {'prettier/vim-prettier', run = 'yarn install' }
  use { 'hoob3rt/lualine.nvim', requires = {'kyazdani42/nvim-web-devicons', opt = true }}

  -- lsp
  use 'neovim/nvim-lspconfig'
  use 'nvim-lua/completion-nvim'
  use 'anott03/nvim-lspinstall'

  -- fuzzy find
  use 'nvim-lua/popup.nvim'
  use 'nvim-lua/plenary.nvim'
  use 'nvim-lua/telescope.nvim'
  use 'jremmen/vim-ripgrep'

  -- etc
  use 'tpope/vim-vinegar'
  use { 'TimUntersberger/neogit', requires = 'nvim-lua/plenary.nvim' }
  use { 
      "nvim-neorg/neorg",
      config = function()
          require('neorg').setup {
              -- Tell Neorg what modules to load
              load = {
                  ["core.defaults"] = {}, -- Load all the default modules
                  ["core.norg.concealer"] = {}, -- Allows for use of icons
                  ["core.norg.dirman"] = { -- Manage your directories with Neorg
                      config = {
                          workspaces = {
                              my_workspace = "~/neorg"
                          }
                      }
                  }
              },
          }
      end,
      requires = "nvim-lua/plenary.nvim"
  }


  end
)

