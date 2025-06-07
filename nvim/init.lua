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


-- Remap ctrl u and ctrl d to center the cursor
vim.api.nvim_set_keymap('n', '<C-d>', '<C-d>zz', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<C-u>', '<C-u>zz', { noremap = true, silent = true })

-- Remap movement keys
vim.api.nvim_set_keymap('n', 'ñ', 'l', { noremap = true, silent = true })  -- ñ moves right
vim.api.nvim_set_keymap('n', 'j', 'h', { noremap = true, silent = true })  -- j moves left
vim.api.nvim_set_keymap('n', 'k', 'j', { noremap = true, silent = true })  -- k moves down
vim.api.nvim_set_keymap('n', 'l', 'k', { noremap = true, silent = true })  -- l moves up
-- Remap for visual mode
vim.api.nvim_set_keymap('v', 'ñ', 'l', { noremap = true, silent = true })  -- ñ moves right
vim.api.nvim_set_keymap('v', 'j', 'h', { noremap = true, silent = true })  -- j moves left
vim.api.nvim_set_keymap('v', 'k', 'j', { noremap = true, silent = true })  -- k moves down
vim.api.nvim_set_keymap('v', 'l', 'k', { noremap = true, silent = true })  -- l moves up

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
