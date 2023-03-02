local eq = assert.are.same

describe("Terminal wrapper:", function()
  describe("always true:", function()
    it("is always true", function ()
      eq(true, true)
    end)
  end)
end)
