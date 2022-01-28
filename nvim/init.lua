-----------------------------------------------------------
-- Import Lua modules
-----------------------------------------------------------

local function loadAll(path)
  local scan = require('plenary.scandir')
  for _, file in ipairs(scan.scan_dir(path, { depth = 0 })) do
      require(file)
  end
end
