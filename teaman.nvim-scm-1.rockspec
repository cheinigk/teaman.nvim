local MODREV, SPECREV = 'scm', '-1'
rockspec_format = '3.0'
package = 'teaman.nvim'
version = MODREV .. SPECREV

description = {
  summary = 'Manage multiple neovim terminals.',
  detailed = [[
  A simple, opinionated neovim plugin for managing multiple builtin terminals.
  The plugin is geared towards simplicity and extensibility, while providing a minimal amount of defaults.
  ]],
  labels = { 'neovim', 'plugin', },
  homepage = 'https://github.com/cheinigk/teaman.nvim',
  license = 'MIT',
}

dependencies = {
  'lua == 5.1',
}

source = {
  url = 'git://github.com/cheinigk/teaman.nvim',
}

build = {
  type = 'builtin',
  copy_directories = {
    'doc',
    'plugin',
  }
}
