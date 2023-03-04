-- Rerun tests only if their modification time changed.
cache = true

std = luajit
codes = true

self = false

globals = {
  "_",
  "vim.g",
}

-- Global objects defined by the C code
read_globals = {
  "vim",
  "describe",
  "it",
}
