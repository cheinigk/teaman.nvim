---@class Terminal
local Terminal = {
  bufnr = nil,
  winnr = nil,
  chanid = nil,
}

local function terminal_create_buf(term)
  rawset(term, "bufnr", vim.api.nvim_create_buf(true, false))
end

local function terminal_create_win(term)
  vim.cmd.split()
  rawset(term, "winnr", vim.api.nvim_get_current_win())
end

local function win_invalid(winnr)
  return not vim.tbl_contains(vim.api.nvim_list_wins(), winnr)
end

local function terminal_termopen(term)
  terminal_create_buf(term)
  vim.api.nvim_win_set_buf(0, term.bufnr)
  local opts = {
    on_exit = function ()
      rawset(term, "chanid", nil)
      term:quit()
    end,
  }
  rawset(term, "chanid", vim.fn.termopen(term.config.shell, opts))
end

---@brief creates a new terminal without opening a window
function Terminal:create()
  require'teaman.utils'.with_restore_current_buf(terminal_termopen, self)
end

---@brief opens the terminal window and opens a new terminal if it does not already exist
function Terminal:open()
  if not (self.bufnr and vim.fn.bufexists(self.bufnr)) then
    require'teaman.utils'.with_restore_current_buf(terminal_create_buf, self)
  end
  if not self.winnr or win_invalid(self.winnr) then
    require'teaman.utils'.with_restore_current_win(terminal_create_win, self)
  end
  if not self.chanid then
    self:create()
  end
  vim.api.nvim_win_set_buf(self.winnr, self.bufnr)
end

---@brief close the terminal window (does not close the terminal)
function Terminal:close()
  local winnr = self.winnr
  self.winnr = nil
  vim.api.nvim_win_close(winnr, false)
end

---@brief toggle the terminal window
function Terminal:toggle()
  local function contains_term(winnr)
    return vim.api.nvim_win_get_buf(winnr) == self.bufnr
  end

  local tabnr = vim.api.nvim_get_current_tabpage()
  local wins = vim.api.nvim_tabpage_list_wins(tabnr)
  local open_terms = vim.tbl_filter(contains_term, wins)
  if #open_terms == 0 then
    self:open()
  else
    self:close()
  end
end

---@brief quit the terminal session (quits the terminal session and deletes the buffer)
function Terminal:quit()
  if self.chanid then
    vim.fn.jobstop(self.chanid)
    -- on_exit will in turn call Terminal:quit
  else
    local bufnr = self.bufnr
    rawset(self, "winnr", nil)
    rawset(self, "bufnr", nil)
    vim.api.nvim_buf_delete(bufnr, {force=true})
  end
end

---@param cmd string @send text to terminal without newline
function Terminal:send_text(cmd)
  vim.validate({
    cmd = {cmd, "string", false},
  })
  vim.api.nvim_chan_send(self.chanid, cmd)
end

---@param line string @send text to terminal with newline
function Terminal:send_line(line)
  vim.validate({
    line = {line, "string", false},
  })
  self:send_text(line)
  self:send_text('\n')
end

---@param motion string @type of vim motion
function Terminal:send_motion(motion)
  vim.validate({
    motion = {motion, "string", true},
  })

  if motion == nil then
    print("Setup operatorfunc")
    require'teaman.utils'.set_opfunc(
      function (m)
        self:send_motion(m)
      end
    )
    return "g@"
  end

  print("Send text to terminal")

  local utils = require'teaman.utils'
  local range = utils.range(motion)
  local lines = utils.covered_lines(motion, range)

  vim.tbl_map(function (line) self:send_line(line) end, lines)
end

local terminal_mt = {
  __index = Terminal,
  __newindex = function (_, _, _)
    error("The Terminal table is constant.")
  end,
  __tostring = function (term)
    local fmt = "Terminal{shell=%q, bufnr=%d, winnr=%d, chanid=%d}"
    local str = string.format(fmt, table.concat(term.config.shell) or "", term.bufnr or -1, term.winnr or -1, term.chanid or -1)
    return str
  end,
}

---@brief constructs a new terminal object
---@param config table @config table
---@return Terminal
function Terminal.new(config)
  vim.validate({
    config = {config, require'teaman.utils'.is_config, "Config|nil"},
  })
  local obj = {
    config = config or require'teaman.config'.new(),
  }
  setmetatable(obj, terminal_mt)
  return obj
end

return Terminal
