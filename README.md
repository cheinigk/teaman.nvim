# `teaman.nvim`

An opinionated simple terminal manager for neovim's built-in terminal. Essentially just a wrapper around `termopen()`.

## Installation

### `packer.nvim`

```lua
use{"cheinigk/teaman.nvim"}
```

## Configuration

Create a global variable with the configuration table. Missing entries
will be defaulted.

```lua
-- Have a look at the following default table. Note, it is not necessary
-- to actually create this global variable, as non-existing entries will
-- be defaulted automatically.
vim.g.teaman = {
}
```

So to change the default shell command, the following configuration table needs to be defined.

```lua
vim.g.teaman = {
  shell = {'/usr/bin/zsh'}, -- Use `zsh` instead of `$SHELL`.
}
```

## Usage

This plugin does not do anything by default. Hence, you have to tell it
how you want to use it. To have a "global" terminal (per `nvim` instance),
you can create the file `~/.config/nvim/after/plugin/teaman.lua` with the content

```lua
-- Filter the terminal by the provided user info.
local function isglobal(term)
  return term.info and term.info.type and term.info.type == "global"
end

-- Create a new terminal with additional user info or return the
-- previously created terminal.
local function first_global_term()
  local teaman = require'teaman'
  local global_terms = teaman.list(isglobal)
  if vim.tbl_isempty(global_terms) then
    local term = Terminal:new(nil, {type = "global"})
    local term = teaman.add(term)
    return term
  else
    return global_terms[1]
  end
end

--
-- Setup keymaps
--
-- Toggle the terminal instance
vim.keymap.set({'n', 't'}, [[<C-\><C-\>]], function ()
  first_global_term():toggle()
end, {})
-- Send text to the terminal
vim.keymap.set({'n','v'}, 'gX', function(m)
  return first_global_term():send_motion(m)
end, {expr=true, desc="Send lines covered by motion to global terminal."})
vim.keymap.set("n", "gXX", "m`0gX$``",
  {remap=true, desc="Send current line to global terminal."})
vim.keymap.set("n", "gX%", "m`gggXG``",
  {remap=true, desc="Send current buffer to global terminal."})
vim.keymap.set("n", "gX<CR>", function ()
  first_global_term():send_text('\n')
end, {desc="Send <CR> to global terminal."})
vim.keymap.set("n", "gXc", function ()
  first_global_term():send_text('')
end, {desc="Send <ctrl-c> to global terminal."})
```

## Development

### Requirements

- `luacheck` to lint the sources
- `stylua` to enforce a coding style
- `lemmy-help` to generate the API `vimdocs` from `lua` files
- `panvimdoc` to generate the user `vimdocs` from `markdown` files 

Have a look at the `Makefile` to see how tests, `luacheck`, and `stylua` is run and generation of docs is done.

## Similar, More Powerful Plugins

Before writing my own terminal manager, I used the following two plugins.

- [toggleterm.nvim](https://github.com/akinsho/toggleterm.nvim)
- [iron.nvim](https://github.com/hkupty/iron.nvim)

Both are well designed and serve a need. I'd advice everyone to choose one
of these, if you want a more convenient though-out terminal manager. The
reason I turned away from both was twofold. First, I wanted one plugin
instead of two. And second, I felt I didn't use a lot of the offered
features.
