local utils = require('usermod.utils')
local set_option = utils.set_option
local map_cmd = utils.map_cmd

-- Move to previous/next
map_cmd('n|<Leader>h', 'BufferPrevious')
map_cmd('n|<Leader>l', 'BufferNext')

-- Re-order to previous/next
map_cmd('n|<Leader><', 'BufferMovePrevious')
map_cmd('n|<Leader>>', 'BufferMoveNext', opts)

-- Goto buffer in position...
map_cmd('n|<Leader>1', 'BufferGoto 1')
map_cmd('n|<Leader>2', 'BufferGoto 2')
map_cmd('n|<Leader>3', 'BufferGoto 3')
map_cmd('n|<Leader>4', 'BufferGoto 4')
map_cmd('n|<Leader>5', 'BufferGoto 5')
map_cmd('n|<Leader>6', 'BufferGoto 6')
map_cmd('n|<Leader>7', 'BufferGoto 7')
map_cmd('n|<Leader>8', 'BufferGoto 8')
map_cmd('n|<Leader>9', 'BufferGoto 9')
map_cmd('n|<Leader>0', 'BufferLast')

-- Close buffer
map_cmd('n|<Leader>dd', 'BufferClose')

-- Wipeout buffer
--                 :BufferWipeout<CR>
-- Close commands
--                 :BufferCloseAllButCurrent<CR>
--                 :BufferCloseBuffersLeft<CR>
--                 :BufferCloseBuffersRight<CR>
-- Magic buffer-picking mode
map_cmd('n|<C-p>', 'BufferPick')
-- Sort automatically by...
map_cmd('n|<Space>bb', 'BufferOrderByBufferNumber')
map_cmd('n|<Space>bd', 'BufferOrderByDirectory')
map_cmd('n|<Space>bl', 'BufferOrderByLanguage')

-- { Basic: }"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
--
-- close other buffers, %bd kill all buffers, e# open last closed buffer
map_cmd('n|<Leader><Leader>o', '%bd|e#')

-- always show vim tabline
set_option({ showtabline = 2 })

