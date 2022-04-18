local utils = require('usermod.utils')
local map = utils.map
local map_cmd = utils.map_cmd
local set_option = utils.set_option

-- map keystroke
map('n|<SPACE>', '<Nop>')
vim.g.mapleader = ' '
map('v|p', '"_s<C-r>"<esc>')
map_cmd('n|<Leader>sv', 'source $MYVIMRC') -- edit and source vimrc

map_cmd('n|<Leader>ag', 'Ag')
map_cmd('n|<Leader>gf', 'GF')

-- set options

vim.cmd('autocmd BufEnter *.png, *.jpg, *.gif exec "silent !open ".expand("%") | :bw')
vim.cmd('syntax enable')


set_option({
  ruler = true,                      --  enable ruler
  laststatus = 2,
  number = true,
  clipboard = 'unnamedplus',         --  use system clipboard
  cursorline = true,
  fdm = 'syntax',
  encoding  = 'utf-8',               --  configure the encoding
  fileencoding = 'utf-8',
  mouse = 'a',                       --  enable mouse

  tabstop = 2,                       --  Insert 2 spaces for a tab
  shiftwidth = 2,                    --  use 2 spaces for shifting

  smarttab = true,                   --  Change the number of space characters inserted for indentation
  expandtab = true,                  --  Makes tabbing smarter will realize you have 2 vs 4
  smartindent = true,                --  Converts tabs to spaces
                                     --  Makes indenting smart
  smartcase = true,      
  ignorecase = true,                 --  Makes search use smart case

  updatetime = 100,                  --  Change vim update delay to update git change sign when edit
  hidden = true,                     --  Can change to other buffer when have unsaved change

  signcolumn = 'yes',                --  Show sign column
})                       

vim.opt.shortmess:append('c')        --  Don't pass messages to |ins-completion-menu|.
vim.opt.formatoptions:remove('cro')  --  Don't append comment while open new line

