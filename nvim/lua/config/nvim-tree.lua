-----------------------------------------------------------
-- File manager configuration file
-----------------------------------------------------------

local g = vim.g

g.nvim_tree_quit_on_open = 0
g.nvim_tree_indent_markers = 1
g.nvim_tree_git_hl = 0
g.nvim_tree_highlight_opened_files = 0
g.nvim_tree_disable_window_picker = 1
g.nvim_tree_respect_buf_cwd = 1
g.nvim_tree_width_allow_resize  = 1
g.nvim_tree_show_icons = {
  git = 1,
  folders = 1,
  files = 1
}

g.nvim_tree_icons = {
	default = "‣ "
}

require('nvim-tree').setup {
  open_on_setup = true,
  update_cwd = true,
  filters = {
    dotfiles = false,
    custom = { '.git', '.bin' },
  },
  git = {
    enable = true,
    ignore = true,
  },
  view = {
    width = 25,
    auto_resize = true
    hide_root_folder = true
  },
  update_cwd = true,
  update_focused_file = {
    enable = true,
    update_cwd = true
  }
}
