local default_config = {
  shell = vim.fn.split(vim.o.shell),
}

local config_mt = {
  -- Lookup key in table `vim.g.teaman` first before defaulting.
  __index = function(self, key)
    if self[key] then
      return self[key]
    elseif vim.g.teaman and vim.g.teaman[key] then
      return vim.g.teaman[key]
    else
      return default_config[key]
    end
  end,
  -- Essentially making this table constant.
  __newindex = function(_, _, _)
    error("The configuration table cannot be changed!", vim.log.levels.ERROR)
  end,
}

local Config = {}

function Config.new(overrides)
  vim.validate({
    config = {overrides, require'teaman.utils'.is_config, "config table"},
  })
  local obj = overrides or {}
  setmetatable(obj, config_mt)
  return obj
end

return Config
