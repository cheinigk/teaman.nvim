local eq = assert.are.same

local function tbl_difference(t1, t2)
  local res = {}
  for _, entry in ipairs(t1) do
    if not vim.tbl_contains(t2, entry) then
      table.insert(res, entry)
    end
  end
  return res
end

describe("Terminal wrapper:", function()
  describe("create a terminal object with default config:", function()
    vim.g.teaman = {
      shell = vim.fn.split(vim.o.shell),
      info = {},
    }
    local terminal = require("teaman.terminal").new()
    it(
      "converts to string",
      function() eq(tostring(terminal), [[Terminal{shell="]] .. vim.o.shell .. [[", bufnr=-1, winnr=-1, chanid=-1}]]) end
    )
    describe(
      "call create()",
      function ()
        local bufnrs = vim.api.nvim_list_bufs()
        terminal:create()
        it(
          "creates a new buffer and a terminal represented by a channel id",
          function ()
            local new_bufnrs = vim.api.nvim_list_bufs()
            local term_bufnr = tbl_difference(new_bufnrs, bufnrs)
            eq(#term_bufnr, 1)
            eq(term_bufnr[1], terminal.bufnr)
            local chan_infos = vim.api.nvim_list_chans()
            local chanids = vim.tbl_map(function (chan_info)
              return chan_info.id
            end, chan_infos)
            eq(vim.tbl_contains(chanids, terminal.chanid), true)
          end
        )
      end
    )
    describe(
      "call open()",
      function ()
        local winnrs = vim.api.nvim_list_wins()
        terminal:open()
        it(
          "creates a new window with the terminal buffer attached",
          function ()
            local new_winnrs = vim.api.nvim_list_wins()
            local term_winnr = tbl_difference(new_winnrs, winnrs)
            eq(#term_winnr, 1)
            eq(term_winnr[1], terminal.winnr)
            local term_winnr_bufnr = vim.api.nvim_win_get_buf(terminal.winnr)
            eq(term_winnr_bufnr, terminal.bufnr)
          end
        )
      end
    )
  end)
end)
