---@mod teaman.init

---@class teaman
local teaman = {}

---@class Terminals Essentially just a list of Terminal objects
local Terminals = {}

---Add a terminal
---@param config Config Config table
---@usage `require'teaman'.add(require'teaman.config'.new())`
function teaman.add(config)
  vim.validate {
    config = { config, require("teaman.utils").is_config, "Config|nil" },
  }
  local term = require("teaman.terminal").new(config)
  table.insert(Terminals, term)
  return term
end

---Remove a terminal
---@param term Terminal table
function teaman.remove(term)
  vim.validate {
    term = { term, require("teaman.utils").is_terminal, "Terminal table" },
  }
  Terminals = vim.tbl_filter(function(t) return t ~= term end, Terminals)
end

---List all terminals
---@return Terminals list of Terminal objects
function teaman.list() return Terminals end

---Filter terminals
---@param predicate function Predicate function used to filter the terminals
---@return Terminals list of Terminal objects
function teaman.filter(predicate)
  vim.validate {
    predicate = { predicate, "function", false },
  }
  return vim.tbl_filter(predicate, Terminals)
end

---Apply a function for all terminals
---@param f function Function acting on a terminal object
---@return Terminals list of Terminal objects
function teaman.map(f)
  vim.validate {
    predicate = { f, "function", false },
  }
  return vim.tbl_map(f, Terminals)
end

return teaman
