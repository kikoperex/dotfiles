local opt = vim.opt

opt.number = true
opt.relativenumber = true
opt.signcolumn = "no"
opt.cursorline = false
opt.ignorecase = true
opt.smartcase = true
opt.hlsearch = false
opt.incsearch = true
opt.swapfile = false
opt.undofile = true
opt.autoread = true
opt.scrolloff = 8
opt.colorcolumn = "80"
opt.tabstop = 4
opt.softtabstop = 4
opt.shiftwidth = 4
opt.expandtab = true
opt.smartindent = true

-- Enable filetype plugins and indenting
vim.cmd('filetype plugin indent on')
