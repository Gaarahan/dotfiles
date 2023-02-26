local builtin = require("telescope.builtin")
local utils = require("usermod.utils")
local lga_actions = require("telescope-live-grep-args.actions")
local map = utils.map
local lua_fn = utils.lua_fn

require("telescope").setup({
	defaults = {
		vimgrep_arguments = {
			"rg",
			"--color=never",
			"--no-heading",
			"--with-filename",
			"--line-number",
			"--column",
			"--smart-case",
		},
	},
	extensions = {
		live_grep_args = {
			auto_quoting = true, -- enable/disable auto-quoting
			mappings = { -- extend mappings
				i = {
					["<C-i>"] = lga_actions.quote_prompt({ postfix = " --iglob " }),
					["<C-h>"] = lga_actions.quote_prompt({ postfix = " --no-ignore " }),
				},
			},
		},
	},
})
