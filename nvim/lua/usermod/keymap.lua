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
map_cmd('n|<Leader>cl', 'noh')
map_cmd('n|<Leader>hi', 'History')
map_cmd('n|<leader>ms', 'Mason')

-- Start interactive EasyAlign in visual mode (e.g. vipga)
map('x|ga', '<Plug>(EasyAlign)', { noremap = false })

-- easymotion
-- <Leader>f{char} to move to {char}
map('n|<leader>f', '<Plug>(easymotion-overwin-f)')

-- s{char}{char} to move to {char}{char}
map('n|<leader>s', '<Plug>(easymotion-overwin-f2)')

-- Move to line
map('n|<leader>L', '<Plug>(easymotion-overwin-line)')

-- Move to word
map('n|<leader>w', '<Plug>(easymotion-overwin-w)')

