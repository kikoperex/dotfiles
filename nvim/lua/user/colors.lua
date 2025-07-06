-- Enhanced pywal configuration that works perfectly with Treesitter

-- Function to apply pywal colors (enhanced for Treesitter)
local function apply_wal_colors()
    -- Source the pywal colors
    vim.cmd('source ~/.cache/wal/colors-wal.vim')

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
    
    -- Clear existing highlights
    vim.cmd('highlight clear')
    vim.o.background = 'dark'
    
    -- Basic UI highlights
    vim.api.nvim_set_hl(0, 'Normal', { fg = colors.foreground, bg = 'NONE' })
    vim.api.nvim_set_hl(0, 'Cursor', { fg = colors.background, bg = colors.cursor })
    vim.api.nvim_set_hl(0, 'CursorLine', { bg = colors.color0 })
    vim.api.nvim_set_hl(0, 'LineNr', { fg = colors.color8 })
    vim.api.nvim_set_hl(0, 'CursorLineNr', { fg = colors.color15, bold = true })
    vim.api.nvim_set_hl(0, 'ColorColumn', { bg = colors.color0 })
    
    -- Treesitter highlight groups (these work with any language)
    vim.api.nvim_set_hl(0, '@comment', { fg = colors.color8, italic = true })
    vim.api.nvim_set_hl(0, '@string', { fg = colors.color2 })
    vim.api.nvim_set_hl(0, '@number', { fg = colors.color9 })
    vim.api.nvim_set_hl(0, '@boolean', { fg = colors.color9 })
    vim.api.nvim_set_hl(0, '@float', { fg = colors.color9 })
    vim.api.nvim_set_hl(0, '@function', { fg = colors.color4 })
    vim.api.nvim_set_hl(0, '@function.call', { fg = colors.color4 })
    vim.api.nvim_set_hl(0, '@function.builtin', { fg = colors.color12 })
    vim.api.nvim_set_hl(0, '@method', { fg = colors.color4 })
    vim.api.nvim_set_hl(0, '@method.call', { fg = colors.color4 })
    vim.api.nvim_set_hl(0, '@keyword', { fg = colors.color1, bold = true })
    vim.api.nvim_set_hl(0, '@keyword.function', { fg = colors.color1, bold = true })
    vim.api.nvim_set_hl(0, '@keyword.return', { fg = colors.color1, bold = true })
    vim.api.nvim_set_hl(0, '@keyword.operator', { fg = colors.color1, bold = true })
    vim.api.nvim_set_hl(0, '@conditional', { fg = colors.color1, bold = true })
    vim.api.nvim_set_hl(0, '@repeat', { fg = colors.color1, bold = true })
    vim.api.nvim_set_hl(0, '@exception', { fg = colors.color1, bold = true })
    vim.api.nvim_set_hl(0, '@include', { fg = colors.color1, bold = true })
    vim.api.nvim_set_hl(0, '@type', { fg = colors.color3 })
    vim.api.nvim_set_hl(0, '@type.builtin', { fg = colors.color11 })
    vim.api.nvim_set_hl(0, '@type.definition', { fg = colors.color3, bold = true })
    vim.api.nvim_set_hl(0, '@variable', { fg = colors.foreground })
    vim.api.nvim_set_hl(0, '@variable.builtin', { fg = colors.color6, italic = true })
    vim.api.nvim_set_hl(0, '@constant', { fg = colors.color5 })
    vim.api.nvim_set_hl(0, '@constant.builtin', { fg = colors.color13 })
    vim.api.nvim_set_hl(0, '@constant.macro', { fg = colors.color5 })
    vim.api.nvim_set_hl(0, '@constructor', { fg = colors.color3 })
    vim.api.nvim_set_hl(0, '@operator', { fg = colors.color15 })
    vim.api.nvim_set_hl(0, '@punctuation', { fg = colors.color7 })
    vim.api.nvim_set_hl(0, '@punctuation.bracket', { fg = colors.color7 })
    vim.api.nvim_set_hl(0, '@punctuation.delimiter', { fg = colors.color7 })
    vim.api.nvim_set_hl(0, '@punctuation.special', { fg = colors.color13 })
    
    -- Python-specific Treesitter highlights
    vim.api.nvim_set_hl(0, '@variable.parameter.python', { fg = colors.color14 })
    vim.api.nvim_set_hl(0, '@function.builtin.python', { fg = colors.color12 })
    vim.api.nvim_set_hl(0, '@constant.builtin.python', { fg = colors.color9 }) -- None, True, False
    vim.api.nvim_set_hl(0, '@keyword.import.python', { fg = colors.color1, bold = true })
    vim.api.nvim_set_hl(0, '@decorator.python', { fg = colors.color5 })
    vim.api.nvim_set_hl(0, '@string.documentation.python', { fg = colors.color8, italic = true })
    
    -- JavaScript/TypeScript specific
    vim.api.nvim_set_hl(0, '@constructor.javascript', { fg = colors.color3 })
    vim.api.nvim_set_hl(0, '@keyword.export.javascript', { fg = colors.color1, bold = true })
    vim.api.nvim_set_hl(0, '@variable.parameter.javascript', { fg = colors.color14 })
    
    -- Markup languages (HTML, Markdown, etc.)
    vim.api.nvim_set_hl(0, '@tag', { fg = colors.color1 })
    vim.api.nvim_set_hl(0, '@tag.attribute', { fg = colors.color3 })
    vim.api.nvim_set_hl(0, '@tag.delimiter', { fg = colors.color7 })
    vim.api.nvim_set_hl(0, '@markup.heading', { fg = colors.color4, bold = true })
    vim.api.nvim_set_hl(0, '@markup.strong', { fg = colors.color15, bold = true })
    vim.api.nvim_set_hl(0, '@markup.italic', { fg = colors.color15, italic = true })
    vim.api.nvim_set_hl(0, '@markup.link', { fg = colors.color6, underline = true })
    vim.api.nvim_set_hl(0, '@markup.raw', { fg = colors.color2 })
    
    -- Fallback to traditional syntax groups for compatibility
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
    
    -- Error and diagnostic highlights
    vim.api.nvim_set_hl(0, 'Error', { fg = colors.color1, bold = true })
    vim.api.nvim_set_hl(0, 'Warning', { fg = colors.color11, bold = true })
    vim.api.nvim_set_hl(0, 'ErrorMsg', { fg = colors.color1, bold = true })
    vim.api.nvim_set_hl(0, 'WarningMsg', { fg = colors.color11, bold = true })
    vim.api.nvim_set_hl(0, 'DiagnosticError', { fg = colors.color1 })
    vim.api.nvim_set_hl(0, 'DiagnosticWarn', { fg = colors.color11 })
    vim.api.nvim_set_hl(0, 'DiagnosticInfo', { fg = colors.color4 })
    vim.api.nvim_set_hl(0, 'DiagnosticHint', { fg = colors.color6 })
    
    -- UI elements
    vim.api.nvim_set_hl(0, 'StatusLine', { fg = colors.foreground, bg = colors.color0 })
    vim.api.nvim_set_hl(0, 'StatusLineNC', { fg = colors.color8, bg = colors.color0 })
    vim.api.nvim_set_hl(0, 'VertSplit', { fg = colors.color8 })
    vim.api.nvim_set_hl(0, 'Pmenu', { fg = colors.foreground, bg = colors.color0 })
    vim.api.nvim_set_hl(0, 'PmenuSel', { fg = colors.background, bg = colors.color6 })
    vim.api.nvim_set_hl(0, 'Visual', { bg = colors.color8 })
    vim.api.nvim_set_hl(0, 'Search', { fg = colors.background, bg = colors.color11 })
    vim.api.nvim_set_hl(0, 'IncSearch', { fg = colors.background, bg = colors.color13 })
    
    -- Telescope highlights
    vim.api.nvim_set_hl(0, 'TelescopeNormal', { fg = colors.foreground, bg = colors.color0 })
    vim.api.nvim_set_hl(0, 'TelescopeBorder', { fg = colors.color8, bg = colors.color0 })
    vim.api.nvim_set_hl(0, 'TelescopePromptBorder', { fg = colors.color8, bg = colors.color0 })
    vim.api.nvim_set_hl(0, 'TelescopeResultsBorder', { fg = colors.color8, bg = colors.color0 })
    vim.api.nvim_set_hl(0, 'TelescopePreviewBorder', { fg = colors.color8, bg = colors.color0 })
    vim.api.nvim_set_hl(0, 'TelescopeSelection', { fg = colors.foreground, bg = colors.color8 })
    vim.api.nvim_set_hl(0, 'TelescopeMatching', { fg = colors.color11, bold = true })
end

-- Apply the colors initially
apply_wal_colors()

-- Auto-apply colors when colorscheme changes (useful when pywal updates)
vim.api.nvim_create_autocmd("ColorScheme", {
    pattern = "*",
    callback = function()
        -- Small delay to ensure pywal colors are loaded
        vim.defer_fn(apply_wal_colors, 50)
    end,
})
