local utils = require("usermod.utils")
local set_option = utils.set_option

-- { Theme: }"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

set_option({
	background = "dark",
	termguicolors = true,
})

vim.cmd("color gruvbox")

-- { Barbar : }"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

-- Set barbar's options
vim.g.bufferline = {
	animation = true,
	auto_hide = false,
	tabpages = true,
	closable = true,
	clickable = true,
	icons = true,

	-- If set, the icon color will follow its corresponding buffer
	-- highlight group. By default, the Buffer*Icon group is linked to the
	-- Buffer* group (see Highlighting below). Otherwise, it will take its
	-- default value as defined by devicons.
	icon_custom_colors = true,

	-- Configure icons on the bufferline.
	icon_separator_active = "▎",
	icon_separator_inactive = "▎",
	icon_close_tab = "",
	icon_close_tab_modified = "●",
	icon_pinned = "車",

	-- Sets the maximum padding width with which to surround each tab
	maximum_padding = 1,

	-- Sets the maximum buffer name length.
	maximum_length = 30,

	-- If set, the letters for each buffer in buffer-pick mode will be
	-- assigned based on their name. Otherwise or in case all letters are
	-- already assigned, the behavior is to assign letters in order of
	-- usability (see order below)
	semantic_letters = true,

	-- New buffer letters are assigned in this order. This order is
	-- optimal for the qwerty keyboard layout but might need adjustement
	-- for other layouts.
	letters = "asdfjkl;ghnmxcvbziowerutyqpASDFJKLGHNMXCVBZIOWERUTYQP",

	-- Sets the name of unnamed buffers. By default format is "[Buffer X]"
	-- where X is the buffer number. But only a static string is accepted here.
	no_name_title = nil,
}

local function hi(name, fg, bg, attr)
	vim.cmd("hi! clear " .. name)

	if attr ~= nil then
		vim.api.nvim_set_hl(0, name, { fg = fg, bg = bg, bold = true })
	elseif fg ~= nil and bg ~= nil then
		vim.api.nvim_set_hl(0, name, { fg = fg, bg = bg })
	end
end

hi("BufferCurrent", "#d4be98", "#504945", "bold")
hi("BufferCurrentIndex", "#d8a657", "#504945")
hi("BufferCurrentMod", "#d8a657", "#504945")
hi("BufferCurrentSign", "#7daea3", "#504945")
hi("BufferCurrentTarget", "#ea6962", "#504945", "bold")
hi("BufferVisible", "#ddc7a1", "#504945")
hi("BufferVisibleIndex", "#d8a657", "#504945")
hi("BufferVisibleMod", "#d8a657", "#504945")
hi("BufferVisibleSign", "#d8a657", "#504945")
hi("BufferVisibleTarget", "red", "#504945", "bold")
hi("BufferInactive", "#a89984", "#32302f")
hi("BufferInactiveIndex")
hi("BufferInactiveMod")
hi("BufferInactiveSign")
hi("BufferInactiveTarget")
hi("BufferCurrentIcon")
hi("BufferVisibleIcon")
hi("BufferInactiveIcon")

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
})
