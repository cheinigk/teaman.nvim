-- The default config.
local config = {
  shell = vim.fn.split(vim.o.shell),
}

local config_mt = {
  -- Lookup key in table `vim.g.teaman` first before defaulting.
  __index = function(self, key)
    if vim.g.teaman and vim.g.teaman[key] then
      return vim.g.teaman[key]
    else
      return self[key]
    end
  end,
  -- Essentially making this table constant.
  __newindex = function(_, _, _)
    error("The configuration table cannot be changed!", vim.log.levels.ERROR)
  end,
}

setmetatable(config, config_mt)

return config
