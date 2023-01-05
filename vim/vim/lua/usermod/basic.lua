local utils = require('usermod.utils')
local set_option = utils.set_option

-- set options

vim.cmd('autocmd BufEnter *.png, *.jpg, *.gif exec "silent !open ".expand("%") | :bw')
vim.cmd('syntax enable')
--  Don't append comment while open new line
vim.cmd('autocmd BufNewFile,BufRead * setlocal formatoptions-=cro')

vim.api.nvim_exec(
  [[
    let $GIT_EDITOR = "nvr -cc vsplit --remote-wait +'set bufhidden=wipe'"
  ]] ,
  false
)


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

