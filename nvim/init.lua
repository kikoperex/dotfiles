-- Set <leader> key
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Load configuration modules
require("user.options")
require("user.keymaps")
require("user.plugins")
require("user.colors")
require("user.treesitter")
require("user.lsp")
require("user.cmp")
require("user.autocmds")

