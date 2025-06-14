vim.g.mapleader = " "
vim.opt.number = true         
vim.wo.relativenumber = true
vim.opt.signcolumn = "no"   
vim.opt.cursorline = false
vim.opt.ignorecase = true    
vim.opt.smartcase = true
vim.opt.hlsearch = false
vim.opt.swapfile = false    
vim.opt.undofile = true      
vim.opt.autoread = true      
vim.opt.syntax = "on"         
vim.cmd('filetype plugin indent on')  
vim.cmd('syntax enable')
vim.opt.scrolloff = 8
vim.opt.colorcolumn = "80"
vim.opt.smartindent= true

vim.keymap.set('n', '<leader>f', vim.cmd.Ex)

-- Telescope
local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>pf', builtin.find_files, { desc = 'Telescope find files' })
vim.keymap.set('n', '<C-p>', builtin.git_files, { desc = 'Telescope find files' })

-- Remap ctrl u and ctrl d to center the cursor
vim.keymap.set('n', '<C-d>', '<C-d>zz', { silent = true, desc = 'Half page down and center' })
vim.keymap.set('n', '<C-u>', '<C-u>zz', { silent = true, desc = 'Half page up and center' })
vim.keymap.set('n', 'n', 'nzzzv', { silent = true, desc = 'Next search result and center' })
vim.keymap.set('n', 'N', 'Nzzzv', { silent = true, desc = 'Previous search result and center' })

-- Remap movement keys - H J K L to J K L Ñ
vim.keymap.set('n', 'ñ', 'l', { silent = true, desc = 'Move right' })
vim.keymap.set('n', 'j', 'h', { silent = true, desc = 'Move left' })
vim.keymap.set('n', 'k', 'j', { silent = true, desc = 'Move down' })
vim.keymap.set('n', 'l', 'k', { silent = true, desc = 'Move up' })

-- Remap for visual mode
vim.keymap.set('v', 'ñ', 'l', { silent = true, desc = 'Move right' })
vim.keymap.set('v', 'j', 'h', { silent = true, desc = 'Move left' })
vim.keymap.set('v', 'k', 'j', { silent = true, desc = 'Move down' })
vim.keymap.set('v', 'l', 'k', { silent = true, desc = 'Move up' })
-- Remap movement keys - H J K L to J K L Ñ (uppercase)
vim.keymap.set('n', 'Ñ', 'L', { silent = true, desc = 'Move to bottom of screen' })
vim.keymap.set('n', 'J', 'H', { silent = true, desc = 'Move to top of screen' })
vim.keymap.set('n', 'K', 'J', { silent = true, desc = 'Join lines' })
vim.keymap.set('n', 'L', 'K', { silent = true, desc = 'Lookup keyword' })

-- Remap for visual mode (uppercase)
vim.keymap.set('v', 'Ñ', 'L', { silent = true, desc = 'Move to bottom of screen' })
vim.keymap.set('v', 'J', 'H', { silent = true, desc = 'Move to top of screen' })
vim.keymap.set('v', 'K', 'J', { silent = true, desc = 'Join lines' })
vim.keymap.set('v', 'L', 'K', { silent = true, desc = 'Lookup keyword' })
-- Optional: Also remap in operator-pending mode for consistency
vim.keymap.set('o', 'j', 'h', { desc = 'Move left' })
vim.keymap.set('o', 'k', 'j', { desc = 'Move down' })
vim.keymap.set('o', 'l', 'k', { desc = 'Move up' })
vim.keymap.set('o', 'ñ', 'l', { desc = 'Move right' })

-- vim.api.nvim_set_keymap('v', 'K', "m: '>+1<CR>gv=gv", { noremap = true, silent = true })  -- l moves up
-- vim.api.nvim_set_keymap('v', 'L', "m: '<-2<CR>gv=gv", { noremap = true, silent = true })  -- l moves up

vim.keymap.set("v", "K", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "L", ":m '<-2<CR>gv=gv")

-- Source the pywal colors
vim.cmd('source ~/.cache/wal/colors-wal.vim')

-- Function to apply pywal colors
local function apply_wal_colors()
    local colors = {
        background = vim.g.background,
        foreground = vim.g.foreground,
        cursor = vim.g.cursor,
        color0 = vim.g.color0,
        color1 = vim.g.color1,
        color2 = vim.g.color2,
        color3 = vim.g.color3,
        color4 = vim.g.color4,
        color5 = vim.g.color5,
        color6 = vim.g.color6,
        color7 = vim.g.color7,
        color8 = vim.g.color8,
        color9 = vim.g.color9,
        color10 = vim.g.color10,
        color11 = vim.g.color11,
        color12 = vim.g.color12,
        color13 = vim.g.color13,
        color14 = vim.g.color14,
        color15 = vim.g.color15,
    }
    
    -- Apply the colors
    vim.cmd('highlight clear')
    vim.cmd('syntax reset')
    vim.o.background = 'dark'
    
    -- Set basic highlights with default background
    vim.api.nvim_set_hl(0, 'Normal', { fg = colors.foreground, bg = 'NONE' })
    vim.api.nvim_set_hl(0, 'Cursor', { fg = colors.background, bg = colors.cursor })
    vim.api.nvim_set_hl(0, 'CursorLine', { bg = colors.color0 })
    vim.api.nvim_set_hl(0, 'LineNr', { fg = colors.color8 })
    vim.api.nvim_set_hl(0, 'CursorLineNr', { fg = colors.color15, bold = true })
    
    -- General syntax highlighting
    vim.api.nvim_set_hl(0, 'Comment', { fg = colors.color8, italic = true })
    vim.api.nvim_set_hl(0, 'String', { fg = colors.color2 })
    vim.api.nvim_set_hl(0, 'Number', { fg = colors.color9 })
    vim.api.nvim_set_hl(0, 'Boolean', { fg = colors.color9 })
    vim.api.nvim_set_hl(0, 'Float', { fg = colors.color9 })
    vim.api.nvim_set_hl(0, 'Function', { fg = colors.color4 })
    vim.api.nvim_set_hl(0, 'Keyword', { fg = colors.color1, bold = true })
    vim.api.nvim_set_hl(0, 'Type', { fg = colors.color3 })
    vim.api.nvim_set_hl(0, 'Identifier', { fg = colors.color6 })
    vim.api.nvim_set_hl(0, 'Constant', { fg = colors.color5 })
    vim.api.nvim_set_hl(0, 'PreProc', { fg = colors.color9 })
    vim.api.nvim_set_hl(0, 'Special', { fg = colors.color13 })
    vim.api.nvim_set_hl(0, 'Operator', { fg = colors.color15 })
    vim.api.nvim_set_hl(0, 'Delimiter', { fg = colors.color7 })
    
    -- Python-specific highlighting
    vim.api.nvim_set_hl(0, 'pythonBuiltin', { fg = colors.color4 })
    vim.api.nvim_set_hl(0, 'pythonFunction', { fg = colors.color4 })
    vim.api.nvim_set_hl(0, 'pythonDecorator', { fg = colors.color5 })
    vim.api.nvim_set_hl(0, 'pythonDecoratorName', { fg = colors.color5 })
    vim.api.nvim_set_hl(0, 'pythonStatement', { fg = colors.color1, bold = true })
    vim.api.nvim_set_hl(0, 'pythonConditional', { fg = colors.color1, bold = true })
    vim.api.nvim_set_hl(0, 'pythonRepeat', { fg = colors.color1, bold = true })
    vim.api.nvim_set_hl(0, 'pythonException', { fg = colors.color1, bold = true })
    vim.api.nvim_set_hl(0, 'pythonOperator', { fg = colors.color15 })
    vim.api.nvim_set_hl(0, 'pythonImport', { fg = colors.color1, bold = true })
    vim.api.nvim_set_hl(0, 'pythonClass', { fg = colors.color3, bold = true })
    vim.api.nvim_set_hl(0, 'pythonClassName', { fg = colors.color3, bold = true })
    vim.api.nvim_set_hl(0, 'pythonSelf', { fg = colors.color6, italic = true })
    vim.api.nvim_set_hl(0, 'pythonDottedName', { fg = colors.color6 })
    vim.api.nvim_set_hl(0, 'pythonString', { fg = colors.color2 })
    vim.api.nvim_set_hl(0, 'pythonRawString', { fg = colors.color10 })
    vim.api.nvim_set_hl(0, 'pythonStrFormat', { fg = colors.color13 })
    vim.api.nvim_set_hl(0, 'pythonStrFormatting', { fg = colors.color13 })
    vim.api.nvim_set_hl(0, 'pythonDocstring', { fg = colors.color8, italic = true })
    vim.api.nvim_set_hl(0, 'pythonComment', { fg = colors.color8, italic = true })
    vim.api.nvim_set_hl(0, 'pythonTodo', { fg = colors.color11, bold = true })
    
    -- Additional Python keywords for better syntax support
    vim.api.nvim_set_hl(0, 'pythonAsync', { fg = colors.color1, bold = true })
    vim.api.nvim_set_hl(0, 'pythonAwait', { fg = colors.color1, bold = true })
    vim.api.nvim_set_hl(0, 'pythonInclude', { fg = colors.color1, bold = true })
    vim.api.nvim_set_hl(0, 'pythonNone', { fg = colors.color9 })
    vim.api.nvim_set_hl(0, 'pythonEscape', { fg = colors.color13 })
    
    -- Error and warning highlights
    vim.api.nvim_set_hl(0, 'Error', { fg = colors.color1, bold = true })
    vim.api.nvim_set_hl(0, 'Warning', { fg = colors.color11, bold = true })
    vim.api.nvim_set_hl(0, 'ErrorMsg', { fg = colors.color1, bold = true })
    vim.api.nvim_set_hl(0, 'WarningMsg', { fg = colors.color11, bold = true })
    
    -- UI elements
    vim.api.nvim_set_hl(0, 'StatusLine', { fg = colors.foreground, bg = colors.color0 })
    vim.api.nvim_set_hl(0, 'StatusLineNC', { fg = colors.color8, bg = colors.color0 })
    vim.api.nvim_set_hl(0, 'VertSplit', { fg = colors.color8 })
    vim.api.nvim_set_hl(0, 'Pmenu', { fg = colors.foreground, bg = colors.color0 })
    vim.api.nvim_set_hl(0, 'PmenuSel', { fg = colors.background, bg = colors.color6 })
    vim.api.nvim_set_hl(0, 'Visual', { bg = colors.color8 })
    vim.api.nvim_set_hl(0, 'Search', { fg = colors.background, bg = colors.color11 })
    vim.api.nvim_set_hl(0, 'IncSearch', { fg = colors.background, bg = colors.color13 })
end

-- Apply the colors
apply_wal_colors()



-- This file can be loaded by calling `lua require('plugins')` from your init.vim

-- Only required if you have packer configured as `opt`
vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function(use)
  -- Packer can manage itself
  use 'wbthomason/packer.nvim'

  use {
	  'nvim-telescope/telescope.nvim', tag = '0.1.8',
	  -- or                            , branch = '0.1.x',
	  requires = { {'nvim-lua/plenary.nvim'} }
  }

  use {
	  'nvim-treesitter/nvim-treesitter',
	  run = function()
		  local ts_update = require('nvim-treesitter.install').update({ with_sync = true })
		  ts_update()
	  end,
  }

end)

