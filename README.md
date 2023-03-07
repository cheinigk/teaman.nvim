# User Documentation

An opinionated simple terminal manager for neovim's built-in terminal.
Essentially just a wrapper around `termopen()`.

## Installation

### `packer.nvim`

```lua
use{"cheinigk/teaman.nvim"}
```

## Configuration

Create a global variable with the configuration table. Missing entries will be
defaulted.

```lua
-- Have a look at the following default table. Note, it is not necessary
-- to actually create this global variable, as non-existing entries will
-- be defaulted automatically.
vim.g.teaman = {
}
```

So to change the default shell command, the following configuration table needs
to be defined.

```lua
vim.g.teaman = {
  shell = {'/usr/bin/zsh'}, -- Use `zsh` instead of `$SHELL`.
}
```

## Usage

This plugin does not do anything by default. Hence, you have to tell it how you
want to use it. To have a "global" terminal (per `nvim` instance), you can
create the file `~/.config/nvim/after/plugin/teaman.lua` with the content

```lua
-- Filter the terminal by the provided user info.
local function is_global_term(term)
  local has_info = term.config ~= nil and term.config.info ~= nil
  if not has_info then
    return false
  end

  return term.config.info.type ~= nil and term.config.info.type == "global"
end

-- Create a new terminal with additional user info or return the
-- previously created terminal.
local function first_global_term()
  local terminal_manager = require'teaman'
  local global_terms = terminal_manager.list(is_global_term)
  if vim.tbl_isempty(global_terms) then
    local term_config = require'teaman.config'.new{info = {type = 'global'}}
    local term = terminal_manager.add(term_config)
    return term
  else
    return global_terms[1]
  end
end

--
-- Setup keymaps
--
-- Toggle the terminal instance
vim.keymap.set({'n', 't'}, "<leader>tt", function ()
  first_global_term():toggle()
end, {desc = "toggle global terminal window"})
-- Send text to the terminal
vim.keymap.set({'n','v'}, '<leader>tx', function(m)
  return first_global_term():send_motion(m)
end, {expr=true, desc="Send lines covered by motion to global terminal."})
vim.keymap.set("n", "<leader>txx", "m`0<leader>tx$``",
  {remap=true, desc="Send current line to global terminal."})
vim.keymap.set("n", "<leader>tx%", "m`gg<leader>txG``",
  {remap=true, desc="Send current buffer to global terminal."})
vim.keymap.set("n", "<leader>tx<CR>", function ()
  first_global_term():send_text('\n')
end, {desc="Send <CR> to global terminal."})
vim.keymap.set("n", "<leader>txc", function ()
  first_global_term():send_text('')
end, {desc="Send <ctrl-c> to global terminal."})
```

## Similar Plugins

Before writing my own terminal manager, I used the following two plugins:

- [toggleterm.nvim](https://github.com/akinsho/toggleterm.nvim)
- [iron.nvim](https://github.com/hkupty/iron.nvim)

Both are way more powerful, well-designed, and serve a particular need. I'd
advise everyone to choose one of these, if you want a more convenient
thought-out terminal manager. The reason I turned away from both was twofold.
First, I wanted one plugin instead of two to handle my terminal usage within
neovim. Second, I felt I didn't use a lot of the offered features from either
of the plugins.

# Acknowledgement

Obviously, I couldn't write this plugin without ideas taken from others. The
plugin's structure follows [mfussenegger's blog
post](https://zignar.net/2022/11/06/structuring-neovim-lua-plugins/). Having
a terminal, which is shared within neovim instance, and, which can be toggled for
ease of interaction, stems from
`[toggleterm.nvim](https://github.com/akinsho/toggleterm.nvim)`. The idea to
send commands to a terminal and setting up different Shells/REPLs I got from
`[iron.nvim](https://github.com/hkupty/iron.nvim)`.

# Developer Documentation

## Requirements

- `luacheck` to lint the sources
- `stylua` to enforce a coding style
- [`lemmy-help`](https://github.com/numToStr/lemmy-help) to generate the API `vimdocs` from `lua` files
- [`panvimdoc`](https://github.com/kdheepak/panvimdoc) to generate the user `vimdocs` from `markdown` files 
- [`plenary.nvim`](https://github.com/nvim-lua/plenary.nvim) to write and execute tests.

Have a look at the [`Makefile`](./Makefile) to see how tests using `luassert` and `busted`
from `plenary.nvim`, linting with `luacheck`, and formatting with `stylua` are
run. The generation of docs is done via a github action (c.f.
[`.github/workflows/main.yml`](./.github/workflows/main.yml)).

