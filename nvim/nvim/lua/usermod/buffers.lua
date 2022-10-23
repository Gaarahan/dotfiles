local utils = require('usermod.utils')
local set_option = utils.set_option
local map_cmd = utils.map_cmd

-- Move to previous/next
map_cmd('n|<Leader>[', 'BufferPrevious')
map_cmd('n|<Leader>]', 'BufferNext')

-- Re-order to previous/next
map_cmd('n|<Leader><', 'BufferMovePrevious')
map_cmd('n|<Leader>>', 'BufferMoveNext', opts)

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
-- close other buffers
map_cmd('n|<Leader>bo', 'BufferCloseAllButCurrent')

-- always show vim tabline
set_option({ showtabline = 2 })
