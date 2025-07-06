local opt = vim.opt

opt.number = true
opt.relativenumber = true
opt.signcolumn = "no"
opt.cursorline = false
opt.ignorecase = true
opt.smartcase = true
opt.hlsearch = false
opt.swapfile = false
opt.undofile = true
opt.autoread = true
opt.scrolloff = 8
opt.colorcolumn = "80"
opt.smartindent = true

-- Enable filetype plugins and indenting
vim.cmd('filetype plugin indent on')
