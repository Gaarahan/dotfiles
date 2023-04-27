local utils = require("usermod.utils")
local set_option = utils.set_option

-- { Theme: }"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

set_option({
	background = "dark",
	termguicolors = true,
})

vim.cmd("color gruvbox")

local customize_onedark = require("lualine.themes.onedark")
customize_onedark.normal.a.bg = "#5DD02E"

-- { Status line: }"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

require("lualine").setup({
	options = {
		theme = customize_onedark,
		component_separators = { left = "|", right = "|" },
		section_separators = { left = "", right = "" },
	},
	sections = {
		lualine_a = { "mode" },
		lualine_b = { "branch", "diff", "diagnostics" },
		lualine_c = { { "filename", path = 1 } },
		lualine_x = { "encoding", "fileformat", "filetype" },
		lualine_y = { "progress" },
		lualine_z = { "location" },
	},
})

-- { Prompt: }"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

require("dressing").setup({
	select = {
		get_config = function(opts)
			if opts.kind == "legendary.nvim" then
				return {
					telescope = {
						sorter = require("telescope.sorters").fuzzy_with_index_bias({}),
					},
				}
			else
				return {}
			end
		end,
	},
	input = {
		enabled = false,
	},
})

-- { Home page: }"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

vim.g.startify_change_to_dir = 0
vim.g.startify_lists = {
	{ type = "dir", header = { "   MRU" .. vim.fn.getcwd() } },
	{ type = "sessions", header = { "   Sessions" } },
	{ type = "bookmarks", header = { "   Bookmarks" } },
	{ type = "commands", header = { "   Commands" } },
}
