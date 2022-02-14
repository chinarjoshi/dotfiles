-----------------------------------------------------------
-- Plugin manager initialization
-----------------------------------------------------------

local install_path = vim.fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
  packer_bootstrap = vim.fn.system({'git', 'clone', 'https://github.com/wbthomason/packer.nvim', install_path})
end
vim.cmd [[packadd packer.nvim]]
vim.cmd [[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost plugins.lua source <afile> | PackerSync
  augroup end
]]

require('packer').init {
  display = {
    open_fn = function()
      return require('packer.util').float { border = 'rounded' }
    end,
  },
}

require('plugins.plugins')

for _, module in ipairs({
	'bufferline',
	'cmp',
	'icons',
	'lspconfig',
	'lspkind_icons',
	'nvimtree',
	'others',
	'statusline',
	'telescope',
	'treesitter',
}) do
  require('plugins.config.' .. module)
end
