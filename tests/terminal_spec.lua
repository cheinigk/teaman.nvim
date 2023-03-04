local eq = assert.are.same

describe("Terminal wrapper:", function()
  describe("always true:", function()
    it("is always true", function ()
      eq(true, true)
    end)
  end)
  describe("create a terminal object:", function()
    vim.g.teaman = {
      shell = vim.fn.split(vim.o.shell),
      info = {},
    }
    local terminal = require"teaman.terminal".new()
    eq(tostring(terminal), [[Terminal{shell="bash", bufnr=-1, winnr=-1, chanid=-1}]])
  end)
end)
