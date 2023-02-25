local M = {}

---@class Terminals @contains Terminal objects
local Terminals = {}

---@brief Add a terminal
---@param config Config @config table
---@param info table @custom info table
function M.add(config)
  vim.validate({
    config = {config, require'teaman.utils'.is_config, "Config|nil"},
  })
  local term = require'teaman.terminal'.new(config)
  table.insert(Terminals, term)
  return term
end

---@brief remove a terminal
---@param term Terminal table
function M.remove(term)
  vim.validate({
    term = {term, require'teaman.utils'.is_terminal, "Terminal table"},
  })
  Terminals = vim.tbl_filter(
    function(t) return t ~= term end,
    Terminals
  )
end

---@brief list all terminals
---@return Terminals list of Terminal objects
function M.list()
  return Terminals
end

---@brief filter terminals
---@param predicate function Predicate function used to filter the terminals
---@return Terminals list of Terminal objects
function M.filter(predicate)
  vim.validate({
    predicate = {predicate, "function", false},
  })
  return vim.tbl_filter(predicate, Terminals)
end

---@brief apply a function for all terminals
---@param f function Function acting on a terminal object
---@return Terminals list of Terminal objects
function M.map(f)
  vim.validate({
    predicate = {f, "function", false},
  })
  return vim.tbl_map(f, Terminals)
end

return M
