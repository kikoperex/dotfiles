-- Auto commands

-- Auto-apply colors when colorscheme changes (useful when pywal updates)
vim.api.nvim_create_autocmd("ColorScheme", {
    pattern = "*",
    callback = function()
        -- Small delay to ensure pywal colors are loaded
        vim.defer_fn(require("user.colors").apply_wal_colors, 50)
    end,
})
