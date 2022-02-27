local present, packer = pcall(require, 'packer')

if not present then
   local packer_path = vim.fn.stdpath 'data' .. '/site/pack/packer/opt/packer.nvim'

   print 'Cloning packer..'
   vim.fn.delete(packer_path, 'rf')
   vim.fn.system {
      'git',
      'clone',
      'https://github.com/wbthomason/packer.nvim',
      packer_path,
   }

   vim.cmd 'packadd packer.nvim'
   present, packer = pcall(require, 'packer')

   if present then
      print 'Packer cloned successfully.'
   else
      error('Couldn\'t clone packer !\nPacker path: ' .. packer_path .. '\n' .. packer)
   end
end

packer.init {
   display = {
      open_fn = function()
         return require('packer.util').float { border = 'single' }
      end,
      prompt_border = 'single',
   },
   git = {
      clone_timeout = 6000,
   },
   auto_clean = true,
   compile_on_sync = true,
}

-- Testing comment
local scan = require('plenary.scandir').scan_dir
for _, file in ipairs(scan('/home/c/dotfiles/nvim/lua/plugins/configs')) do
  local ok, err = pcall(dofile, file)
  if not ok then
    error('Error loading ' .. file .. '\n\n' .. err)
  end
end


return packer
