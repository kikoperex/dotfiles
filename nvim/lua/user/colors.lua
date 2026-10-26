vim.cmd("hi clear")
if vim.fn.exists("syntax_on") then
    vim.cmd("syntax reset")
end

vim.o.termguicolors = true
vim.g.colors_name = "haz"

-- HAZ — derivada de wallhaven-xe5pxo_3840x2160.png
local colors = {
    bg = "#121616",
    fg = "#c7cace",
    black = "#191e1e",

    -- Rampa del wallpaper
    void = "#0b0e0d",
    raised = "#212729",
    border = "#333c41",
    muted = "#838d95",
    grey = "#a6adb4",
    silver = "#c7cace",
    white = "#e6e8e9",

    -- Acento: el haz
    beam = "#d8e6ea",
    beam_dim = "#9fb4ba",

    -- Señales susurradas
    red = "#c2665f",
    red_hi = "#d17a72",
    green = "#86a38c",
    green_hi = "#9fbca5",
    yellow = "#bfa877",
    yellow_hi = "#d8c29b",
    blue = "#7c97ab",
    blue_hi = "#9bb6c9",
    magenta = "#9e8ba8",
    magenta_hi = "#bcaac5",
    cyan = "#82a6a1",
    cyan_hi = "#a2c4bf",

    selection = "#212729",
    comment = "#5c666d",
}

local hl = vim.api.nvim_set_hl

-- Base
hl(0, "Normal", { fg = colors.fg, bg = colors.bg })
hl(0, "NormalNC", { fg = colors.muted, bg = colors.bg })
hl(0, "NormalFloat", { fg = colors.fg, bg = colors.black })
hl(0, "FloatBorder", { fg = colors.border, bg = colors.black })
hl(0, "Cursor", { fg = colors.void, bg = colors.beam })
hl(0, "CursorLine", { bg = colors.black })
hl(0, "CursorColumn", { bg = colors.black })
hl(0, "CursorLineNr", { fg = colors.beam, bold = true })
hl(0, "LineNr", { fg = colors.comment })
hl(0, "SignColumn", { bg = colors.bg })
hl(0, "VertSplit", { fg = colors.border, bg = colors.bg })
hl(0, "WinSeparator", { fg = colors.border, bg = colors.bg })
hl(0, "StatusLine", { fg = colors.white, bg = colors.raised, bold = true })
hl(0, "StatusLineNC", { fg = colors.muted, bg = colors.black })
hl(0, "Visual", { bg = colors.selection })
hl(0, "VisualNOS", { bg = colors.selection })
hl(0, "Pmenu", { fg = colors.fg, bg = colors.black })
hl(0, "PmenuSel", { fg = colors.void, bg = colors.beam, bold = true })
hl(0, "PmenuSbar", { bg = colors.raised })
hl(0, "PmenuThumb", { bg = colors.border })
hl(0, "Search", { fg = colors.void, bg = colors.yellow_hi })
hl(0, "IncSearch", { fg = colors.void, bg = colors.beam, bold = true })
hl(0, "MatchParen", { fg = colors.beam, bold = true, underline = true })
hl(0, "NonText", { fg = colors.border })
hl(0, "Folded", { fg = colors.muted, bg = colors.black })
hl(0, "FoldColumn", { fg = colors.comment, bg = colors.bg })

-- Sintaxis: el color solo cuando significa algo
hl(0, "Comment", { fg = colors.comment, italic = true })
hl(0, "Constant", { fg = colors.magenta })
hl(0, "String", { fg = colors.green })
hl(0, "Character", { fg = colors.green })
hl(0, "Number", { fg = colors.magenta })
hl(0, "Boolean", { fg = colors.magenta })
hl(0, "Float", { fg = colors.magenta })
hl(0, "Identifier", { fg = colors.fg })
hl(0, "Function", { fg = colors.white, bold = true })
hl(0, "Statement", { fg = colors.blue_hi })
hl(0, "Conditional", { fg = colors.blue_hi })
hl(0, "Repeat", { fg = colors.blue_hi })
hl(0, "Label", { fg = colors.blue_hi })
hl(0, "Operator", { fg = colors.muted })
hl(0, "Keyword", { fg = colors.blue_hi, bold = true })
hl(0, "Exception", { fg = colors.red })
hl(0, "PreProc", { fg = colors.yellow })
hl(0, "Include", { fg = colors.yellow })
hl(0, "Define", { fg = colors.yellow })
hl(0, "Macro", { fg = colors.yellow })
hl(0, "PreCondit", { fg = colors.yellow })
hl(0, "Type", { fg = colors.cyan })
hl(0, "StorageClass", { fg = colors.cyan })
hl(0, "Structure", { fg = colors.cyan })
hl(0, "Typedef", { fg = colors.cyan })
hl(0, "Special", { fg = colors.beam })
hl(0, "SpecialChar", { fg = colors.beam })
hl(0, "Tag", { fg = colors.beam })
hl(0, "Delimiter", { fg = colors.grey })
hl(0, "SpecialComment", { fg = colors.comment })
hl(0, "Debug", { fg = colors.beam })
hl(0, "Underlined", { underline = true })
hl(0, "Ignore", { fg = colors.bg })
hl(0, "Error", { fg = colors.void, bg = colors.red })
hl(0, "Todo", { fg = colors.void, bg = colors.yellow_hi, bold = true })

-- Git
hl(0, "GitSignsAdd", { fg = colors.green_hi })
hl(0, "GitSignsChange", { fg = colors.yellow_hi })
hl(0, "GitSignsDelete", { fg = colors.red_hi })
