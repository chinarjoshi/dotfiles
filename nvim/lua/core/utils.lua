local M = {}

M.rep = function(table)
  if type(table[1]) == 'string' then
    table[1] = '<cmd>' .. table[1] .. '<cr>'
  elseif type(table) == 'table' then
    for _, v in pairs(table) do
      M.rep(v)
    end
  end
end

M.map = function(key, command)
  vim.api.nvim_set_keymap('n', key, command, { noremap = true, silent = true })
end

M.setup = function(name, dependent)
  dependent = dependent or false
  if dependent then
    return require('plugins.configs._').name
  else
    return require('plugins.configs.' .. name)
  end
end

M.vars = {
  theme = 'onedark',
  transparent = false,
  file_ignore_patterns = {
    'theme/*',
    'highlighters/*',
  },
}

return M
