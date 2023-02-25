if 1 ~= vim.fn.has "nvim-0.7.0" then
  vim.api.nvim_err_writeln "Teaman.nvim requires at least nvim-0.7.0."
  return
end

if vim.g.loaded_teaman == 1 then
  return
end
vim.g.loaded_teaman = 1
