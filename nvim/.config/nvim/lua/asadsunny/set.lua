vim.opt.nu = true
vim.opt.relativenumber = true

vim.opt.autoread = true
vim.opt.confirm = true
vim.cmd([[
  autocmd FocusGained,BufEnter,CursorHold,CursorHoldI * checktime
]])

vim.opt.hlsearch = false
vim.opt.incsearch = true

vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.smartindent = true
vim.opt.autoindent = true
vim.opt.scrolloff = 8
vim.opt.wrap = true

vim.cmd("filetype plugin indent on") -- Enable filetype-specific indentation

-- vim.o.laststatus = 2
