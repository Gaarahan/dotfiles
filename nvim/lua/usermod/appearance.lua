local utils = require("usermod.utils")
local set_option = utils.set_option

-- { Theme: }"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

set_option({
	background = "dark",
	termguicolors = true,
})

vim.cmd("color gruvbox")

-- { Lualine.nvim : }"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

local customize_onedark = require("lualine.themes.onedark")

customize_onedark.normal.a.bg = "#5DD02E"

require("lualine").setup({
	options = {
		icons_enabled = true,
		theme = customize_onedark,
		component_separators = { left = "|", right = "|" },
		section_separators = { left = "", right = "" },
		disabled_filetypes = {},
		always_divide_middle = true,
	},
	sections = {
		lualine_a = { "mode" },
		lualine_b = { "branch", "diff", "diagnostics" },
		lualine_c = { "filename" },
		lualine_x = { "encoding", "fileformat", "filetype" },
		lualine_y = { "progress" },
		lualine_z = { "location" },
	},
	inactive_sections = {
		lualine_a = {},
		lualine_b = {},
		lualine_c = { "filename" },
		lualine_x = { "location" },
		lualine_y = {},
		lualine_z = {},
	},
	tabline = {},
	extensions = {},
})

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
