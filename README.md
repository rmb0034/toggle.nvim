# toggle.nvim

A Neovim plugin to toggle windows.

## Installation



Using [nvim.pack]

```lua
vim.pack.add({"rmb0034/pin.nvim"})
require("toggle").setup()
```


## Usage

```lua
require('toggle').setup({
  { 
    type = 'terminal', 
    keybind = '<C-t>',
    startup = function(win, buf)
      -- Optional startup function
    end
  }
})
```
