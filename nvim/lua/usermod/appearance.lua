local utils = require("usermod.utils")
local set_option = utils.set_option
local map_cmd = utils.map_cmd

-- { Theme: }"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

set_option({
	background = "dark",
	termguicolors = true,
})

vim.cmd("color gruvbox")

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
