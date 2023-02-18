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

map(
	"n|<leader>ff",
	lua_fn(function()
		builtin.find_files()
	end)
)
map(
	"n|<leader>fd",
	lua_fn(function()
		require("telescope").extensions.dir.live_grep()
	end)
)
map(
	"n|<leader>fg",
	lua_fn(function()
		require("telescope").extensions.live_grep_args.live_grep_args()
	end)
)
map(
	"n|<leader>fr",
	lua_fn(function()
		builtin.resume()
	end)
)
map(
	"n|<leader>fb",
	lua_fn(function()
		builtin.current_buffer_fuzzy_find()
	end)
)
map(
	"n|<leader>fh",
	lua_fn(function()
		builtin.help_tags()
	end)
)
