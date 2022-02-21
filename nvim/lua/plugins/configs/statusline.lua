colors = require('hl_themes.onedark')
lsp = require('feline.providers.lsp')
lsp_severity = vim.diagnostic.severity
config = {
  hidden = {
    'help',
    'dashboard',
    'NvimTree',
    'terminal',
  },
  shown = {},
  shortline = true,
  style = '',
}

icon_styles = {
   default = {
      left = '',
      right = ' ',
      main_icon = '  ',
      vi_mode_icon = ' ',
      position_icon = ' ',
   },
   arrow = {
      left = '',
      right = '',
      main_icon = '  ',
      vi_mode_icon = ' ',
      position_icon = ' ',
   },

   block = {
      left = ' ',
      right = ' ',
      main_icon = '   ',
      vi_mode_icon = '  ',
      position_icon = '  ',
   },

   round = {
      left = '',
      right = '',
      main_icon = '  ',
      vi_mode_icon = ' ',
      position_icon = ' ',
   },

   slant = {
      left = ' ',
      right = ' ',
      main_icon = '  ',
      vi_mode_icon = ' ',
      position_icon = ' ',
   },
}

-- statusline style
statusline_style = icon_styles[require('vars').statusline_theme]

-- show short statusline on small screens
shortline = config.shortline == false and true

-- Initialize the components table
components = {
   active = {},
   inactive = {}
}

main_icon = {
   provider = statusline_style.main_icon,

   hl = {
      fg = colors.statusline_bg,
      bg = colors.nord_blue,
   },

   right_sep = {
      str = statusline_style.right,
      hl = {
         fg = colors.nord_blue,
         bg = colors.lightbg,
      },
   },
}

inactive_main_icon = {
   provider = statusline_style.main_icon,

   hl = {
      fg = colors.white,
      bg = colors.lightbg,
   },

   right_sep = {
      str = statusline_style.right,
      hl = {
         fg = colors.one_bg2,
         bg = colors.lightbg,
      },
   },
}

file_name = {
   provider = function()
      local filename = vim.fn.expand '%:t'
      local extension = vim.fn.expand '%:e'
      local icon = require('nvim-web-devicons').get_icon(filename, extension)
      if icon == nil then
         icon = ' '
         return icon
      end
      return ' ' .. icon .. ' ' .. filename .. ' '
   end,
   enabled = shortline or function(winid)
      return vim.api.nvim_win_get_width(tonumber(winid) or 0) > 70
   end,
   hl = {
      fg = colors.white,
      bg = colors.lightbg,
   },

   right_sep = {
      str = statusline_style.right,
      hl = { fg = colors.lightbg, bg = colors.lightbg2 },
   },
}

dir_name = {
   provider = function()
      local dir_name = vim.fn.fnamemodify(vim.fn.getcwd(), ':t')
      return '  ' .. dir_name .. ' '
   end,

   enabled = shortline or function(winid)
      return vim.api.nvim_win_get_width(tonumber(winid) or 0) > 80
   end,

   hl = {
      fg = colors.grey_fg2,
      bg = colors.lightbg2,
   },
   right_sep = {
      str = statusline_style.right,
      hi = {
         fg = colors.lightbg2,
         bg = colors.statusline_bg,
      },
   },
}

diff = {
   add = {
      provider = 'git_diff_added',
      hl = {
         fg = colors.grey_fg2,
         bg = colors.statusline_bg,
      },
      icon = ' ',
   },

   change = {
      provider = 'git_diff_changed',
      hl = {
         fg = colors.grey_fg2,
         bg = colors.statusline_bg,
      },
      icon = '  ',
   },

   remove = {
      provider = 'git_diff_removed',
      hl = {
         fg = colors.grey_fg2,
         bg = colors.statusline_bg,
      },
      icon = '  ',
   },
}

git_branch = {
   provider = 'git_branch',
   enabled = shortline or function(winid)
      return vim.api.nvim_win_get_width(tonumber(winid) or 0) > 70
   end,
   hl = {
      fg = colors.grey_fg2,
      bg = colors.statusline_bg,
   },
   icon = '  ',
}

diagnostic = {
   error = {
      provider = 'diagnostic_errors',
      enabled = function()
         return lsp.diagnostics_exist(lsp_severity.ERROR)
      end,

      hl = { fg = colors.red },
      icon = '  ',
   },

   warning = {
      provider = 'diagnostic_warnings',
      enabled = function()
         return lsp.diagnostics_exist(lsp_severity.WARN)
      end,
      hl = { fg = colors.yellow },
      icon = '  ',
   },

   hint = {
      provider = 'diagnostic_hints',
      enabled = function()
         return lsp.diagnostics_exist(lsp_severity.HINT)
      end,
      hl = { fg = colors.grey_fg2 },
      icon = '  ',
   },

   info = {
      provider = 'diagnostic_info',
      enabled = function()
         return lsp.diagnostics_exist(lsp_severity.INFO)
      end,
      hl = { fg = colors.green },
      icon = '  ',
   },
}

lsp_progress = {
   provider = function()
      local Lsp = vim.lsp.util.get_progress_messages()[1]

      if Lsp then
         local msg = Lsp.message or ''
         local percentage = Lsp.percentage or 0
         local title = Lsp.title or ''
         local spinners = {
            '',
            '',
            '',
         }

         local success_icon = {
            '',
            '',
            '',
         }

         local ms = vim.loop.hrtime() / 1000000
         local frame = math.floor(ms / 120) % #spinners

         if percentage >= 70 then
            return string.format(' %%<%s %s %s (%s%%%%) ', success_icon[frame + 1], title, msg, percentage)
         end

         return string.format(' %%<%s %s %s (%s%%%%) ', spinners[frame + 1], title, msg, percentage)
      end

      return ''
   end,
   enabled = shortline or function(winid)
      return vim.api.nvim_win_get_width(tonumber(winid) or 0) > 80
   end,
   hl = { fg = colors.green },
}

lsp_icon = {
   provider = function()
      if next(vim.lsp.buf_get_clients()) ~= nil then
         return '  LSP'
      else
         return ''
      end
   end,
   enabled = shortline or function(winid)
      return vim.api.nvim_win_get_width(tonumber(winid) or 0) > 70
   end,
   hl = { fg = colors.grey_fg2, bg = colors.statusline_bg },
}

mode_colors = {
   ['n'] = { 'NORMAL', colors.red },
   ['no'] = { 'N-PENDING', colors.red },
   ['i'] = { 'INSERT', colors.dark_purple },
   ['ic'] = { 'INSERT', colors.dark_purple },
   ['t'] = { 'TERMINAL', colors.green },
   ['v'] = { 'VISUAL', colors.cyan },
   ['V'] = { 'V-LINE', colors.cyan },
   [''] = { 'V-BLOCK', colors.cyan },
   ['R'] = { 'REPLACE', colors.orange },
   ['Rv'] = { 'V-REPLACE', colors.orange },
   ['s'] = { 'SELECT', colors.nord_blue },
   ['S'] = { 'S-LINE', colors.nord_blue },
   [''] = { 'S-BLOCK', colors.nord_blue },
   ['c'] = { 'COMMAND', colors.pink },
   ['cv'] = { 'COMMAND', colors.pink },
   ['ce'] = { 'COMMAND', colors.pink },
   ['r'] = { 'PROMPT', colors.teal },
   ['rm'] = { 'MORE', colors.teal },
   ['r?'] = { 'CONFIRM', colors.teal },
   ['!'] = { 'SHELL', colors.green },
}

chad_mode_hl = function()
   return {
      fg = mode_colors[vim.fn.mode()][2],
      bg = colors.one_bg,
   }
end

empty_space = {
   provider = ' ' .. statusline_style.left,
   hl = {
      fg = colors.one_bg2,
      bg = colors.statusline_bg,
   },
}

-- this matches the vi mode color
empty_spaceColored = {
   provider = statusline_style.left,
   hl = function()
      return {
         fg = mode_colors[vim.fn.mode()][2],
         bg = colors.one_bg2,
      }
   end,
}

empty_space2 = {
   provider = function()
      return ' ' .. mode_colors[vim.fn.mode()][1] .. ' '
   end,
   hl = chad_mode_hl,
}

mode_icon = {
   provider = statusline_style.vi_mode_icon,
   hl = function()
      return {
         fg = colors.statusline_bg,
         bg = mode_colors[vim.fn.mode()][2],
      }
   end,
}

separator_right = {
   provider = statusline_style.left,
   enabled = shortline or function(winid)
      return vim.api.nvim_win_get_width(tonumber(winid) or 0) > 90
   end,
   hl = {
      fg = colors.grey,
      bg = colors.one_bg,
   },
}

separator_right2 = {
   provider = statusline_style.left,
   enabled = shortline or function(winid)
      return vim.api.nvim_win_get_width(tonumber(winid) or 0) > 90
   end,
   hl = {
      fg = colors.green,
      bg = colors.grey,
   },
}

position_icon = {
   provider = statusline_style.position_icon,
   enabled = shortline or function(winid)
      return vim.api.nvim_win_get_width(tonumber(winid) or 0) > 90
   end,
   hl = {
      fg = colors.black,
      bg = colors.green,
   },
}

current_line = {
   provider = function()
      local current_line = vim.fn.line '.'
      local total_line = vim.fn.line '$'

      if current_line == 1 then
         return ' Top '
      elseif current_line == vim.fn.line '$' then
         return ' Bot '
      end
      local result, _ = math.modf((current_line / total_line) * 100)
      return ' ' .. result .. '%% '
   end,

   enabled = shortline or function(winid)
      return vim.api.nvim_win_get_width(tonumber(winid) or 0) > 90
   end,

   hl = {
      fg = colors.green,
      bg = colors.one_bg,
   },
}


inactive_empty_space = {
   provider = ' ' .. statusline_style.left,
   hl = {
      fg = colors.one_bg,
      bg = colors.statusline_bg,
   },
}

inactive_empty_spaceColored = {
   provider = statusline_style.left,
   hl = function()
      return {
         fg = colors.grey,
         bg = colors.one_bg,
      }
   end,
}

inactive_mode_icon = {
   provider = statusline_style.vi_mode_icon,
   hl = function()
      return {
         fg = colors.white,
         bg = colors.grey,
      }
   end,
}

inactive_empty_space2 = {
   provider = function()
      return ' ' .. mode_colors[vim.fn.mode()][1] .. ' '
   end,
   hl = {
      fg = colors.grey_fg2,
      bg = colors.one_bg,
   }
}
-- TODO:

inactive_separator_right = {
   provider = statusline_style.left,
   enabled = shortline or function(winid)
      return vim.api.nvim_win_get_width(tonumber(winid) or 0) > 90
   end,
   hl = {
      fg = colors.one_bg,
      bg = colors.one_bg,
   },
}
inactive_separator_right2 = {
   provider = statusline_style.left,
   enabled = shortline or function(winid)
      return vim.api.nvim_win_get_width(tonumber(winid) or 0) > 90
   end,
   hl = {
      fg = colors.grey,
      bg = colors.one_bg,
   },
}

inactive_position_icon = {
   provider = statusline_style.position_icon,
   enabled = shortline or function(winid)
      return vim.api.nvim_win_get_width(tonumber(winid) or 0) > 90
   end,
   hl = {
      fg = colors.white,
      bg = colors.grey,
   },
}

inactive_current_line = {
   provider = function()
      local current_line = vim.fn.line '.'
      local total_line = vim.fn.line '$'

      if current_line == 1 then
         return ' Top '
      elseif current_line == vim.fn.line '$' then
         return ' Bot '
      end
      local result, _ = math.modf((current_line / total_line) * 100)
      return ' ' .. result .. '%% '
   end,

   enabled = shortline or function(winid)
      return vim.api.nvim_win_get_width(tonumber(winid) or 0) > 90
   end,

   hl = {
      fg = colors.grey_fg2,
      bg = colors.one_bg,
   },
}

local function add_table(a, b)
   table.insert(a, b)
end

-- components are divided in 3 sections
left = {}
middle = {}
right = {}

inactive_left = {}
inactive_middle = {}
inactive_right = {}

-- left
add_table(left, main_icon)
add_table(left, file_name)
add_table(left, dir_name)
add_table(left, diff.add)
add_table(left, diff.change)
add_table(left, diff.remove)
add_table(left, diagnostic.error)
add_table(left, diagnostic.warning)
add_table(left, diagnostic.hint)
add_table(left, diagnostic.info)

-- Middle
add_table(middle, lsp_progress)

-- right
add_table(right, lsp_icon)
add_table(right, git_branch)
add_table(right, empty_space)
add_table(right, empty_spaceColored)
add_table(right, mode_icon)
add_table(right, empty_space2)
add_table(right, separator_right)
add_table(right, separator_right2)
add_table(right, position_icon)
add_table(right, current_line)


-- left
add_table(inactive_left, inactive_main_icon)
add_table(inactive_left, file_name)
add_table(inactive_left, dir_name)
add_table(inactive_left, diff.add)
add_table(inactive_left, diff.change)
add_table(inactive_left, diff.remove)
add_table(inactive_left, diagnostic.error)
add_table(inactive_left, diagnostic.warning)
add_table(inactive_left, diagnostic.hint)
add_table(inactive_left, diagnostic.info)

-- Middle
add_table(inactive_middle, lsp_progress)

-- right
add_table(inactive_right, lsp_icon)
add_table(inactive_right, git_branch)
add_table(inactive_right, inactive_empty_space)
add_table(inactive_right, inactive_empty_spaceColored)
add_table(inactive_right, inactive_mode_icon)
add_table(inactive_right, inactive_empty_space2)
add_table(inactive_right, inactive_separator_right)
add_table(inactive_right, inactive_separator_right2)
add_table(inactive_right, inactive_position_icon)
add_table(inactive_right, inactive_current_line)

components.active[1] = left
components.active[2] = middle
components.active[3] = right

components.inactive[1] = inactive_left
components.inactive[2] = inactive_middle
components.inactive[3] = inactive_right

require('feline').setup {
   theme = {
      bg = colors.statusline_bg,
      fg = colors.fg,
   },
  components = components,
}
