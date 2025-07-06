local map = vim.keymap.set

-- General keymaps
map('n', '<leader>f', vim.cmd.Ex, { desc = 'Open Netrw (file explorer)' })

-- Telescope
local builtin = require('telescope.builtin')
map('n', '<leader>pf', builtin.find_files, { desc = 'Telescope find files' })
map('n', '<C-p>', builtin.git_files, { desc = 'Telescope find files' })

-- Remap ctrl u and ctrl d to center the cursor
map('n', '<C-d>', '<C-d>zz', { silent = true, desc = 'Half page down and center' })
map('n', '<C-u>', '<C-u>zz', { silent = true, desc = 'Half page up and center' })
map('n', 'n', 'nzzzv', { silent = true, desc = 'Next search result and center' })
map('n', 'N', 'Nzzzv', { silent = true, desc = 'Previous search result and center' })

-- Remap movement keys - H J K L to J K L Ñ
map('n', 'ñ', 'l', { silent = true, desc = 'Move right' })
map('n', 'j', 'h', { silent = true, desc = 'Move left' })
map('n', 'k', 'j', { silent = true, desc = 'Move down' })
map('n', 'l', 'k', { silent = true, desc = 'Move up' })

-- Remap for visual mode
map('v', 'ñ', 'l', { silent = true, desc = 'Move right' })
map('v', 'j', 'h', { silent = true, desc = 'Move left' })
map('v', 'k', 'j', { silent = true, desc = 'Move down' })
map('v', 'l', 'k', { silent = true, desc = 'Move up' })

-- Remap movement keys - H J K L to J K L Ñ (uppercase)
map('n', 'Ñ', 'L', { silent = true, desc = 'Move to bottom of screen' })
map('n', 'J', 'H', { silent = true, desc = 'Move to top of screen' })
map('n', 'K', 'J', { silent = true, desc = 'Join lines' })
map('n', 'L', 'K', { silent = true, desc = 'Lookup keyword' })

-- Remap for visual mode (uppercase)
map('v', 'Ñ', 'L', { silent = true, desc = 'Move to bottom of screen' })
map('v', 'J', 'H', { silent = true, desc = 'Move to top of screen' })
map('v', 'K', 'J', { silent = true, desc = 'Join lines' })
map('v', 'L', 'K', { silent = true, desc = 'Lookup keyword' })

-- Optional: Also remap in operator-pending mode for consistency
map('o', 'j', 'h', { desc = 'Move left' })
map('o', 'k', 'j', { desc = 'Move down' })
map('o', 'l', 'k', { desc = 'Move up' })
map('o', 'ñ', 'l', { desc = 'Move right' })

map("v", "K", ":m '>+1<CR>gv=gv", { desc = 'Move selected lines up'})
map("v", "L", ":m '<-2<CR>gv=gv", { desc = 'Move selected lines down'})

-- Remap for replacing text without copying to the register
map("x", "<leader>p", [["_dP"]], { noremap = true, desc = 'Paste without clobbering register'})
