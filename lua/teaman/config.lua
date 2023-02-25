local default_config = {
  shell = vim.fn.split(vim.o.shell),
  info = {},
}

local config_mt = {
  -- Lookup per terminal user provided config first, then look at global user
  -- provided config, i.e. `vim.g.teaman`. If both fails, return default value.
  __index = function(self, key)
    if rawget(self, key) then
      return rawget(self, key)
    elseif vim.g.teaman and vim.g.teaman[key] then
      return vim.g.teaman[key]
    elseif default_config[key] then
      return default_config[key]
    else
      error("Key \"" .. key .. "\" not found", vim.log.levels.ERROR)
    end
  end,
  -- Essentially making this table constant.
  __newindex = function(_, _, _)
    error("The configuration table is constant and cannot be modified.", vim.log.levels.ERROR)
  end,
}

local Config = {}

function Config.new(overrides)
  vim.validate({
    overrides = {overrides, "table", true},
  })
  local obj = overrides or {}
  setmetatable(obj, config_mt)
  return obj
end

return Config
