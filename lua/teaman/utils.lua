---@mod teaman.utils

local utils = {}

local function is_visual(motion) return string.match(motion or "", "[vV]") end

function utils.range(motion)
  local starting = vim.api.nvim_buf_get_mark(0, is_visual(motion) and "<" or "[")
  local ending = vim.api.nvim_buf_get_mark(0, is_visual(motion) and ">" or "]")
  return {
    starting = starting,
    ending = ending,
  }
end

-- From [user zeertzjq's](https://github.com/zeertzjq)
-- [comment](https://github.com/neovim/neovim/issues/14157#issuecomment-1320787927).
utils.set_opfunc = vim.fn[vim.api.nvim_exec(
  [[
  function s:set_opfunc(val)
    let &operatorfunc = function(a:val)
  endfunction
  echon get(function('s:set_opfunc'), 'name')
]],
  true
)]

function utils.covered_lines(motion, range)
  if motion == "char" then
    return vim.api.nvim_buf_get_text(
      0,
      range.starting[1] - 1,
      range.starting[2],
      range.ending[1] - 1,
      range.ending[2] + 1,
      {}
    )
  elseif motion == "word" then
    return vim.api.nvim_buf_get_text(
      0,
      range.starting[1] - 1,
      range.starting[2],
      range.ending[1] - 1,
      range.ending[2] + 1,
      {}
    )
  elseif motion == "line" then
    return vim.api.nvim_buf_get_lines(0, range.starting[1] - 1, range.ending[1], true)
  end
end

function utils.with_restore_current_win(f, ...)
  local winnr = vim.api.nvim_get_current_win()
  local stat, res = pcall(f, ...)
  vim.api.nvim_set_current_win(winnr)
  if stat and res then return res end
end

function utils.with_restore_current_buf(f, ...)
  local bufnr = vim.api.nvim_get_current_buf()
  local stat, res = pcall(f, ...)
  vim.api.nvim_set_current_buf(bufnr)
  if stat and res then return res end
end

function utils.is_terminal(arg)
  local term = require("teaman.terminal"):new()
  local terminal_mt = getmetatable(term)

  return type(arg) == "table" and getmetatable(arg) == terminal_mt
end
--   print(type(arg))
--   print(vim.inspect(getmetatable(arg)))
--   if type(arg) ~= "table" then
--     return false
--   end
--   local Terminal = require'teaman.terminal'
--   return getmetatable(arg) == getmetatable(Terminal)
-- end

---@param arg table|nil @optional config table
function utils.is_config(arg)
  if arg then
    local config = require("teaman.config").new()
    local config_mt = getmetatable(config)
    return type(arg) == "table" and getmetatable(arg) == config_mt
  end
  return true
end

return utils
