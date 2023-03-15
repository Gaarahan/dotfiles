local utils = require("usermod.utils")
local map_cmd = utils.map_cmd

-- disable netrw at the very start of your init.lua (strongly advised)
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

local function do_nothing(node) end

-- use g? to show help page
require("nvim-tree").setup({
	sort_by = "case_sensitive",
	view = {
		adaptive_size = true,
		mappings = {
			list = {
				{ key = "<C-[>", action = "dir_up" },
				{ key = "-", action = "" },
				{ key = "<Esc>", action = "do_nothing", action_cb = "do_nothing" },
			},
		},
	},
	renderer = {
		group_empty = true,
	},
	filters = {
		dotfiles = true,
	},
	git = {
		enable = true,
	},
})
