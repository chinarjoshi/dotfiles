local colors = require('hl_themes.onedark')
local lsp = require('feline.providers.lsp')
local lsp_severity = vim.diagnostic.severity

local statusline_style = {
  left = '',
  right = ' ',
  main_icon = '  ',
  locked_icon = ' ',
  vi_mode_icon = ' ',
  position_icon = ' ',
}
local shortline = false

local function severity_color()
  local color = 'nord_blue'
  local exists = function(sev) return vim.tbl_count(vim.diagnostic.get(0, {severity = sev})) end
  if exists('Error') > 0 then
    color = 'red'
  elseif exists('Warn') > 0 then
    color = 'yellow'
  elseif exists('Info') > 0 then
    color = 'white'
  elseif exists('Hint') > 0 then
    color = 'blue'
  end
  return color
end

local main_icon = {
  provider = function()
    if vim.bo.readonly then return statusline_style.locked_icon else return statusline_style.main_icon end
  end,
  hl = function()
    return {
      fg = colors.statusline_bg,
      bg = colors[severity_color()],
    }
  end,
   right_sep = function()
    return {
      str = statusline_style.right,
      hl = {
         fg = colors[severity_color()],
         bg = colors.lightbg,
      },
   }
  end
} local inactive_main_icon = {
   provider = vim.bo.readonly and statusline_style.locked_icon or statusline_style.main_icon,
   hl = {
      fg = colors.white,
      bg = colors.one_bg2,
   },
   right_sep = {
      str = statusline_style.right,
      hl = {
         fg = colors.one_bg2,
         bg = colors.lightbg,
      },
   },
}

local file_name = {
   provider = function()
      local filename = vim.fn.expand '%:t'
      local dir_name = vim.fn.fnamemodify(vim.fn.getcwd(), ':t')
      local extension = vim.fn.expand '%:e'
      local icon = require('nvim-web-devicons').get_icon(filename, extension)
      if icon == nil then
         return ' '
      end
      return ' ' .. icon .. ' ' .. dir_name .. '/'.. filename .. ' '
   end,
   enabled = shortline or function(winid)
      return vim.api.nvim_win_get_width(tonumber(winid) or 0) > 70
   end,
   hl = function()
      return {
         fg = vim.bo.modified and colors.red or colors.green,
         bg = colors.lightbg
      }
   end,

   right_sep = {
      str = statusline_style.right,
      hl = { fg = colors.lightbg, bg = colors.lightbg2 },
   },
} local inactive_file_name = {
   provider = function()
      local filename = vim.fn.expand '%:t'
      local dir_name = vim.fn.fnamemodify(vim.fn.getcwd(), ':t')
      local extension = vim.fn.expand '%:e'
      local icon = require('nvim-web-devicons').get_icon(filename, extension)
      if icon == nil then
         return ' '
      end
      return ' ' .. icon .. ' ' .. dir_name .. '/'.. filename .. ' '
   end,
   enabled = shortline or function(winid)
      return vim.api.nvim_win_get_width(tonumber(winid) or 0) > 70
   end,
   hl = {
    fg = colors.grey_fg2,
    bg = colors.lightbg
  },
   right_sep = {
      str = statusline_style.right,
      hl = { fg = colors.lightbg, bg = colors.lightbg2 },
   },
}

local diff = {
   add = {
    provider = 'git_diff_added',
    hl = {
       fg = colors.grey_fg2,
       bg = colors.lightbg2,
    },
    icon = ' ',
   },

   change = {
    provider = 'git_diff_changed',
    hl = {
       fg = colors.grey_fg2,
       bg = colors.lightbg2,
    },
    icon = ' 柳',
   },
   remove = {
    provider = 'git_diff_removed',
    hl = {
       fg = colors.grey_fg2,
       bg = colors.lightbg2,
    },
    icon = '  ',
   },
   separator = {
     provider = statusline_style.right,
     hl = {
        fg = colors.lightbg2,
        bg = colors.statusline_bg,
     },
   },
}

local git_branch = {
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

local diagnostic = {
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

local lsp_progress = {
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

local lsp_icon = {
   provider = function()
      if next(vim.lsp.buf_get_clients()) ~= nil then
        local clients = {}
        for _, client in pairs(vim.lsp.buf_get_clients(0)) do
            clients[#clients + 1] = client.name
        end
         return '  ' .. clients[1]
      else
         return ''
      end
   end,
   enabled = shortline or function(winid)
      return vim.api.nvim_win_get_width(tonumber(winid) or 0) > 70
   end,
   hl = { fg = colors.grey_fg2, bg = colors.statusline_bg },
}

local mode_colors = {
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

local empty_space = {
  {
     provider = ' ' .. statusline_style.left,
     hl = {
        fg = colors.one_bg2,
        bg = colors.statusline_bg,
     },
  },
  {
     provider = statusline_style.left,
     hl = function()
        return {
           fg = mode_colors[vim.fn.mode()][2],
           bg = colors.one_bg2,
        }
     end,
  },
  {
     provider = function()
        return ' ' .. mode_colors[vim.fn.mode()][1] .. ' '
     end,
     hl = {
        fg = mode_colors[vim.fn.mode()][2],
        bg = colors.one_bg,
     }
  },
}

local mode_icon = {
   provider = statusline_style.vi_mode_icon,
   hl = function()
      return {
         fg = colors.statusline_bg,
         bg = mode_colors[vim.fn.mode()][2],
      }
   end,
}

local separator = {
   provider = statusline_style.left,
   enabled = shortline or function(winid)
      return vim.api.nvim_win_get_width(tonumber(winid) or 0) > 90
   end,
   hl = {
      fg = colors.grey,
      bg = colors.one_bg,
   },
   {
     provider = statusline_style.left,
     enabled = shortline or function(winid)
        return vim.api.nvim_win_get_width(tonumber(winid) or 0) > 90
     end,
     hl = {
        fg = colors.black,
        bg = colors.grey,
     },
   }
}

local position_icon = {
   provider = function()
     local scroll_bar_blocks = { '▁', '▂', '▃', '▄', '▅', '▆', '▇', '█' }
     local curr_line = vim.api.nvim_win_get_cursor(0)[1]
     local lines = vim.api.nvim_buf_line_count(0)
     return string.rep(scroll_bar_blocks[math.floor(curr_line / lines * 7) + 1], 2)
   end,
   enabled = shortline or function(winid)
      return vim.api.nvim_win_get_width(tonumber(winid) or 0) > 90
   end,
   hl = {
      fg = colors.green,
      bg = colors.black,
   },
}

local current_line = {
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

local inactive_mode_icon = {
   provider = statusline_style.vi_mode_icon,
   hl = function()
      return {
         fg = colors.white,
         bg = colors.grey,
      }
   end,
}

local inactive_empty_space = {
  {
     provider = ' ' .. statusline_style.left,
     hl = {
        fg = colors.one_bg,
        bg = colors.statusline_bg,
     },
  },
  {
     provider = statusline_style.left,
     hl = function()
        return {
           fg = colors.grey,
           bg = colors.one_bg,
        }
     end,
  },
  {
     provider = function()
        return ' ' .. mode_colors[vim.fn.mode()][1] .. ' '
     end,
     hl = {
        fg = colors.grey_fg2,
        bg = colors.one_bg,
     }
  }
}

local inactive_separator = {
  {
     provider = statusline_style.left,
     enabled = shortline or function(winid)
        return vim.api.nvim_win_get_width(tonumber(winid) or 0) > 90
     end,
     hl = {
        fg = colors.one_bg,
        bg = colors.one_bg,
     },
  },
  {
     provider = statusline_style.left,
     enabled = shortline or function(winid)
        return vim.api.nvim_win_get_width(tonumber(winid) or 0) > 90
     end,
     hl = {
        fg = colors.black,
        bg = colors.one_bg,
     },
  }
}

local inactive_position_icon = {
   provider = function()
     local scroll_bar_blocks = { '▁', '▂', '▃', '▄', '▅', '▆', '▇', '█' }
     local curr_line = vim.api.nvim_win_get_cursor(0)[1]
     local lines = vim.api.nvim_buf_line_count(0)
     return string.rep(scroll_bar_blocks[math.floor(curr_line / lines * 7) + 1], 2)
   end,
   enabled = shortline or function(winid)
      return vim.api.nvim_win_get_width(tonumber(winid) or 0) > 90
   end,
   hl = {
      fg = colors.grey_fg2,
      bg = colors.black,
   },
}

local inactive_current_line = {
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
local left = {}
local middle = {}
local right = {}

local inactive_left = {}
local inactive_middle = {}
local inactive_right = {}

-- left
add_table(left, main_icon)
add_table(left, file_name)
add_table(left, diff.add)
add_table(left, diff.change)
add_table(left, diff.remove)
add_table(left, diff.separator)
add_table(left, diagnostic.error)
add_table(left, diagnostic.warning)
add_table(left, diagnostic.hint)
add_table(left, diagnostic.info)

-- Middle
add_table(middle, lsp_progress)

-- right
add_table(right, lsp_icon)
add_table(right, git_branch)
add_table(right, empty_space[1])
add_table(right, empty_space[2])
add_table(right, mode_icon)
add_table(right, empty_space[3])
add_table(right, separator[1])
add_table(right, separator[2])
add_table(right, position_icon)
add_table(right, current_line)

-- left
add_table(inactive_left, inactive_main_icon)
add_table(inactive_left, inactive_file_name)
add_table(inactive_left, diff.add)
add_table(inactive_left, diff.change)
add_table(inactive_left, diff.remove)
add_table(inactive_left, diff.separator)
add_table(inactive_left, diagnostic.error)
add_table(inactive_left, diagnostic.warning)
add_table(inactive_left, diagnostic.hint)
add_table(inactive_left, diagnostic.info)

-- Middle
add_table(inactive_middle, lsp_progress)

-- right
add_table(inactive_right, lsp_icon)
add_table(inactive_right, git_branch)
add_table(inactive_right, inactive_empty_space[1])
add_table(inactive_right, inactive_empty_space[2])
add_table(inactive_right, inactive_mode_icon)
add_table(inactive_right, inactive_empty_space[3])
add_table(inactive_right, inactive_separator[1])
add_table(inactive_right, inactive_separator[2])
add_table(inactive_right, inactive_position_icon)
add_table(inactive_right, inactive_current_line)

local components = {
   active = {},
   inactive = {}
}

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
