local utils = require('usermod.utils')
local map = utils.map
local map_cmd = utils.map_cmd

-- map general keystroke
map('n|<SPACE>', '<Nop>')
vim.g.mapleader = ' '
map('v|p', '"_s<C-r>"<esc>')
map_cmd('n|<Leader>sv', 'source $MYVIMRC') -- edit and source vimrc

map_cmd('n|<leader>lg', 'LazyGit')
map_cmd('n|<Leader>ag', 'Ag')
map_cmd('n|<Leader>rg', 'Rg')
map_cmd('n|<Leader>gf', 'GF')
map_cmd('n|<Leader>fd', 'Format')
map_cmd('n|<Leader>cl', 'noh')
map_cmd('n|<Leader>hi', 'History')
