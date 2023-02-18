local utils = require("usermod.utils")
local map = utils.map
local map_cmd = utils.map_cmd
local lua_fn = utils.lua_fn
local hop = require("hop")
local directions = require("hop.hint").HintDirection

-- override the default find key
map(
	"n|f",
	lua_fn(function()
		hop.hint_char1({ direction = directions.AFTER_CURSOR, current_line_only = true })
	end, { remap = true })
)
map(
	"n|F",
	lua_fn(function()
		hop.hint_char1({ direction = directions.BEFORE_CURSOR, current_line_only = true })
	end, { remap = true })
)
map(
	"n|t",
	lua_fn(function()
		hop.hint_char1({ direction = directions.AFTER_CURSOR, current_line_only = true, hint_offset = -1 })
	end, { remap = true })
)
map(
	"n|T",
	lua_fn(function()
		hop.hint_char1({ direction = directions.BEFORE_CURSOR, current_line_only = true, hint_offset = 1 })
	end, { remap = true })
)

-- map general keystroke
map("n|<SPACE>", "<Nop>")
vim.g.mapleader = " "
map("v|p", '"_s<C-r>"<esc>')
map_cmd("n|<Leader>sv", "source $MYVIMRC") -- edit and source vimrc

map_cmd("n|<leader>lg", "LazyGit")
map_cmd("n|<Leader>ag", "Ag")
map_cmd("n|<Leader>rg", "Rg")
map_cmd("n|<Leader>gf", "GF")
map_cmd("n|<Leader>cl", "noh")
map_cmd("n|<Leader>hi", "History")
map_cmd("n|<leader>ms", "Mason")
map_cmd("n|<leader>fd", "Format")

-- Start interactive EasyAlign in visual mode (e.g. vipga)
map("x|ga", "<Plug>(EasyAlign)", { noremap = false })
