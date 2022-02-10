local M = {}

M.init = function()
   -- set the global theme, used at various places like theme switcher, highlights
   vim.g.theme = 'onedark'
   base16 = require('base16')
   base16(base16.themes(theme), true)
   package.loaded["colors.highlights" or false] = nil
   -- then load the highlights
   require "colors.highlights"
end

-- returns a table of colors for given or current theme
M.get = function(theme)
   return require("hl_themes." .. vim.g.theme)
end

return M
