-- Automatically generated packer.nvim plugin loader code

if vim.api.nvim_call_function('has', {'nvim-0.5'}) ~= 1 then
  vim.api.nvim_command('echohl WarningMsg | echom "Invalid Neovim version for packer.nvim! | echohl None"')
  return
end

vim.api.nvim_command('packadd packer.nvim')

local no_errors, error_msg = pcall(function()

  local time
  local profile_info
  local should_profile = false
  if should_profile then
    local hrtime = vim.loop.hrtime
    profile_info = {}
    time = function(chunk, start)
      if start then
        profile_info[chunk] = hrtime()
      else
        profile_info[chunk] = (hrtime() - profile_info[chunk]) / 1e6
      end
    end
  else
    time = function(chunk, start) end
  end
  
local function save_profiles(threshold)
  local sorted_times = {}
  for chunk_name, time_taken in pairs(profile_info) do
    sorted_times[#sorted_times + 1] = {chunk_name, time_taken}
  end
  table.sort(sorted_times, function(a, b) return a[2] > b[2] end)
  local results = {}
  for i, elem in ipairs(sorted_times) do
    if not threshold or threshold and elem[2] > threshold then
      results[i] = elem[1] .. ' took ' .. elem[2] .. 'ms'
    end
  end

  _G._packer = _G._packer or {}
  _G._packer.profile_output = results
end

time([[Luarocks path setup]], true)
local package_path_str = "/home/cjoshi/.cache/nvim/packer_hererocks/2.0.5/share/lua/5.1/?.lua;/home/cjoshi/.cache/nvim/packer_hererocks/2.0.5/share/lua/5.1/?/init.lua;/home/cjoshi/.cache/nvim/packer_hererocks/2.0.5/lib/luarocks/rocks-5.1/?.lua;/home/cjoshi/.cache/nvim/packer_hererocks/2.0.5/lib/luarocks/rocks-5.1/?/init.lua"
local install_cpath_pattern = "/home/cjoshi/.cache/nvim/packer_hererocks/2.0.5/lib/lua/5.1/?.so"
if not string.find(package.path, package_path_str, 1, true) then
  package.path = package.path .. ';' .. package_path_str
end

if not string.find(package.cpath, install_cpath_pattern, 1, true) then
  package.cpath = package.cpath .. ';' .. install_cpath_pattern
end

time([[Luarocks path setup]], false)
time([[try_loadstring definition]], true)
local function try_loadstring(s, component, name)
  local success, result = pcall(loadstring(s))
  if not success then
    vim.schedule(function()
      vim.api.nvim_notify('packer.nvim: Error running ' .. component .. ' for ' .. name .. ': ' .. result, vim.log.levels.ERROR, {})
    end)
  end
  return result
end

time([[try_loadstring definition]], false)
time([[Defining packer_plugins]], true)
_G.packer_plugins = {
  ["completion-nvim"] = {
    loaded = true,
    path = "/home/cjoshi/.local/share/nvim/site/pack/packer/start/completion-nvim"
  },
  ["doom-one.nvim"] = {
    loaded = true,
    needs_bufread = false,
    path = "/home/cjoshi/.local/share/nvim/site/pack/packer/opt/doom-one.nvim"
  },
  ["lualine.nvim"] = {
    loaded = true,
    path = "/home/cjoshi/.local/share/nvim/site/pack/packer/start/lualine.nvim"
  },
  ["nvim-lspconfig"] = {
    loaded = true,
    path = "/home/cjoshi/.local/share/nvim/site/pack/packer/start/nvim-lspconfig"
  },
  ["nvim-lspinstall"] = {
    loaded = true,
    path = "/home/cjoshi/.local/share/nvim/site/pack/packer/start/nvim-lspinstall"
  },
  ["nvim-treesitter"] = {
    loaded = true,
    path = "/home/cjoshi/.local/share/nvim/site/pack/packer/start/nvim-treesitter"
  },
  ["nvim-web-devicons"] = {
    loaded = true,
    path = "/home/cjoshi/.local/share/nvim/site/pack/packer/start/nvim-web-devicons"
  },
  ["packer.nvim"] = {
    loaded = true,
    path = "/home/cjoshi/.local/share/nvim/site/pack/packer/start/packer.nvim"
  },
  ["plenary.nvim"] = {
    loaded = true,
    path = "/home/cjoshi/.local/share/nvim/site/pack/packer/start/plenary.nvim"
  },
  ["popup.nvim"] = {
    loaded = true,
    path = "/home/cjoshi/.local/share/nvim/site/pack/packer/start/popup.nvim"
  },
  ["telescope.nvim"] = {
    loaded = true,
    path = "/home/cjoshi/.local/share/nvim/site/pack/packer/start/telescope.nvim"
  },
  ["vim-prettier"] = {
    loaded = true,
    path = "/home/cjoshi/.local/share/nvim/site/pack/packer/start/vim-prettier"
  },
  ["vim-ripgrep"] = {
    loaded = true,
    path = "/home/cjoshi/.local/share/nvim/site/pack/packer/start/vim-ripgrep"
  },
  ["vim-vinegar"] = {
    loaded = true,
    path = "/home/cjoshi/.local/share/nvim/site/pack/packer/start/vim-vinegar"
  }
}

time([[Defining packer_plugins]], false)
-- Setup for: doom-one.nvim
time([[Setup for doom-one.nvim]], true)
try_loadstring("\27LJ\1\2…\3\0\0\3\0\b\0\v4\0\0\0%\1\1\0>\0\2\0027\0\2\0003\1\3\0003\2\4\0:\2\5\0013\2\6\0:\2\a\1>\0\2\1G\0\1\0\25plugins_integrations\1\0\14\vbarbar\2\14nvim_tree\2\rwhichkey\2\14dashboard\2\15bufferline\1\rgitsigns\2\21indent_blankline\2\19vim_illuminate\2\flspsaga\1\rstartify\2\nneorg\2\14telescope\1\vneogit\2\14gitgutter\1\rpumblend\1\0\2\24transparency_amount\3\20\venable\2\1\0\5\22enable_treesitter\2\20terminal_colors\1\20cursor_coloring\1\20italic_comments\1\27transparent_background\1\nsetup\rdoom-one\frequire\0", "setup", "doom-one.nvim")
time([[Setup for doom-one.nvim]], false)
time([[packadd for doom-one.nvim]], true)
vim.cmd [[packadd doom-one.nvim]]
time([[packadd for doom-one.nvim]], false)
if should_profile then save_profiles() end

end)

if not no_errors then
  vim.api.nvim_command('echohl ErrorMsg | echom "Error in packer_compiled: '..error_msg..'" | echom "Please check your config for correctness" | echohl None')
end
