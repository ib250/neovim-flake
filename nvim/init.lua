local cmd = vim.cmd
local fn = vim.fn
local opt = vim.o
local g = vim.g

-- <leader> key. Defaults to `\`. Some people prefer space.
g.mapleader = ';'
-- g.maplocalleader = ' '

opt.compatible = false

-- Enable true colour support
if fn.has('termguicolors') then
  opt.termguicolors = true
end

-- See :h <option> to see what the options do

-- Search down into subfolders
opt.path = vim.o.path .. '**'

opt.number = true
opt.relativenumber = true
opt.cursorline = true
opt.lazyredraw = true
opt.showmatch = true -- Highlight matching parentheses, etc
opt.incsearch = true
opt.hlsearch = true
opt.spell = true
opt.spelllang = 'en'
opt.expandtab = true
opt.tabstop = 2
opt.softtabstop = 2
opt.shiftwidth = 2
opt.foldenable = true
opt.history = 2000
opt.nrformats = 'bin,hex' -- 'octal'
opt.undofile = true
opt.splitright = true
opt.splitbelow = true
opt.cmdheight = 0
opt.fillchars = [[eob: ,fold: ,foldopen:+,foldsep: ,foldclose:-]]
opt.clipboard = "unnamedplus"
opt.ignorecase = true
opt.smartcase = true
opt.hlsearch = true
opt.cursorline = false
opt.autochdir = true


-- Configure Neovim diagnostic messages

vim.diagnostic.config {
  virtual_text = false,
  signs = false,
  update_in_insert = false,
  underline = true,
  severity_sort = true,
  float = {
    focusable = false,
    style = 'minimal',
    border = 'rounded',
    source = 'always',
    header = '',
    prefix = '',
  },
}

g.editorconfig = true

vim.opt.colorcolumn = '100'

-- Native plugins
cmd.filetype('plugin', 'indent', 'on')
cmd.packadd('cfilter') -- Allows filtering the quickfix list with :cfdo

-- let sqlite.lua (which some plugins depend on) know where to find sqlite
vim.g.sqlite_clib_path = require('luv').os_getenv('LIBSQLITE')

-- this should be at the end, because
-- it causes neovim to source ftplugins
-- on the packpath when passing a file to the nvim command
cmd.colorscheme([[catppuccin]])
cmd.syntax('on')
cmd.syntax('enable')

-- muscle memory things...
vim.keymap.set('i', 'jk', '<ESC>')
vim.keymap.set('i', 'kj', '<ESC>')
vim.keymap.set('c', 'jk', '<ESC>')
vim.keymap.set('c', 'kj', '<ESC>')
vim.keymap.set('v', 'jk', '<ESC>')
vim.keymap.set('v', 'kj', '<ESC>')
vim.keymap.set('n', '<c-p>', '<cmd>Telescope<cr>', { desc = 'Telescope command pallete' })
vim.keymap.set('n', 'qq', '<ESC>')
vim.keymap.set('n', '<leader> ', '<cmd>noh<cr>', { desc = 'Clear all highlights' })
