local cmd = vim.cmd
local colors = require('hl_themes.onedark')

-- Foreground colors
for foreground, color in pairs({
  Comment = 'grey_fg',
  cursorlinenr = 'white',
  EndOfBuffer = 'black',
  FloatBorder = 'blue',
  CmpItemAbbr = 'white',
  CmpItemAbbrMatch = 'white',
  CmpItemKind = 'white',
  CmpItemMenu = 'white',
  StatusLineNC = 'one_bg3',
  LineNr = 'grey',
  NvimInternalError = 'red',
  VertSplit = 'one_bg2',
  DashboardCenter = 'grey_fg',
  DashboardFooter = 'grey_fg',
  DashboardHeader = 'grey_fg',
  DashboardShortcut = 'grey_fg',
  IndentBlanklineChar = 'line',
  IndentBlanklineSpaceChar = 'line',
  DiagnosticHint = 'purple',
  DiagnosticError = 'red',
  DiagnosticWarn = 'yellow',
  DiagnosticInformation = 'green',
  NvimTreeEmptyFolderName = 'folder_bg',
  NvimTreeEndOfBuffer = 'darker_black',
  NvimTreeFolderIcon = 'folder_bg',
  NvimTreeFolderName = 'folder_bg',
  NvimTreeGitDirty = 'red',
  NvimTreeIndentMarker = 'one_bg2',
  NvimTreeOpenedFolderName = 'folder_bg',
}) do
  cmd('hi ' .. foreground .. ' guifg=' .. colors[color])
end

-- Background colors
for background, color in pairs({
  NormalFloat = 'darker_black',
  CursorLine = 'darker_black',
  Pmenu = 'one_bg',
  PmenuSbar = 'pmenu_bg',
  PmenuSel = 'nord_blue',
  PmenuThumb = 'darker_black',
  NvimTreeNormalNC = 'darker_black',
  TelescopeNormal = 'darker_black',
  TelescopeSelection = 'black2',
}) do
  cmd('hi ' .. background .. ' guibg=' .. colors[color])
end

-- Both background and foreground colors
for both, color in pairs({
  DiffAdd = {'blue', 'NONE'},
  DiffChange = {'grey_fg', 'NONE'},
  DiffChangeDelete = {'red', 'NONE'},
  DiffModified = {'red', 'NONE'},
  DiffDelete= {'red', 'NONE'},
  NvimTreeStatuslineNc = {'darker_black', 'darker_black'},
  NvimTreeVertSplit = {'darker_black', 'darker_black'},
  NvimTreeWindowPicker = {'red', 'black2'},
  TelescopeBorder = {'darker_black', 'darker_black'},
  TelescopePromptBorder = {'black2', 'black2'},
  TelescopePromptNormal = {'white', 'black2'},
  TelescopePromptPrefix = {'red', 'black2'},
  TelescopePreviewTitle = {'black', 'green'},
  TelescopePromptTitle = {'black', 'red'},
  TelescopeResultsTitle = {'darker_black', 'darker_black'},
}) do
  cmd('hi ' .. both .. ' guifg=' .. colors[color[1]] .. ' guibg=' .. (color[2] == 'NONE' and 'NONE' or colors[color[2]]))
end

if false then
   bg('Normal', 'NONE')
   bg('Folded', 'NONE')
   bg('NormalFloat', 'NONE')
   bg('NvimTreeNormal', 'NONE')
   bg('NvimTreeNormalNC', 'NONE')
   bg('NvimTreeStatusLineNC', 'NONE')
   bg('TelescopeBorder', 'NONE')
   bg('TelescopePrompt', 'NONE')
   bg('TelescopeResults', 'NONE')
   bg('TelescopePromptBorder', 'NONE')
   bg('TelescopePromptNormal', 'NONE')
   bg('TelescopeNormal', 'NONE')
   bg('TelescopePromptPrefix', 'NONE')
   fg('Folded', 'NONE')
   fg('Comment', grey)
   fg('TelescopeBorder', one_bg)
   fg_bg('TelescopeResultsTitle', black, blue)
   fg_bg('NvimTreeVertSplit', grey, 'NONE')
end
