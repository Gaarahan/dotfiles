local utils = require("usermod.utils")
local map = utils.map
local map_cmd = utils.map_cmd

require("gitsigns").setup({
	-- { Line_blame : }"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
	current_line_blame = true, -- Toggle with `:Gitsigns toggle_current_line_blame`
	current_line_blame_opts = {
		virt_text = true,
		virt_text_pos = "right_align", -- 'eol' | 'overlay' | 'right_align'
		delay = 1000,
		ignore_whitespace = false,
	},
	current_line_blame_formatter = "<author>, <author_time:%Y-%m-%d> - <summary>",
})
