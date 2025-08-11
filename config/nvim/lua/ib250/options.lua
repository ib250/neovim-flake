vim.loader.enable()
vim.g.mapleader = ";"
vim.g.maplocalleader = " "
vim.g.editorconfig = true
vim.o.winborder = "solid"
vim.opt.autochdir = true
vim.o.number = true
vim.o.relativenumber = true
vim.o.signcolumn = "yes:1"
vim.o.termguicolors = true
vim.o.wrap = true
vim.o.tabstop = 4
vim.o.swapfile = false
vim.o.smartcase = true

vim.g.ts_max_filesize_kb = 1000

vim.schedule(function()
  vim.opt.clipboard = 'unnamedplus'
end)
