local utils = require("usermod.utils")
local map = utils.map
local map_cmd = utils.map_cmd
local lua_fn = utils.lua_fn

-- disable virtual_text
vim.diagnostic.config({
	virtual_text = false,
})

map_cmd("n|<leader>ac", "Lspsaga code_action")
map_cmd("n|<leader>rn", "Lspsaga rename")

map_cmd("n|<leader>ld", "Lspsaga show_line_diagnostics")
map_cmd("n|<leader>cd", "Lspsaga show_cursor_diagnostics")

map_cmd("n|gr", "Lspsaga lsp_finder")
map_cmd("n|gd", "Lspsaga peek_definition")

-- go to diagnsotic
map_cmd("n|[e", "Lspsaga diagnostic_jump_prev", { silent = true })
map_cmd("n|]e", "Lspsaga diagnostic_jump_next", { silent = true })

map(
	"n|[E",
	lua_fn(function()
		require("lspsaga.diagnostic").goto_prev({ severity = vim.diagnostic.severity.ERROR })
	end),
	{ silent = true }
)
map(
	"n|]E",
	lua_fn(function()
		require("lspsaga.diagnostic").goto_next({ severity = vim.diagnostic.severity.ERROR })
	end),
	{ silent = true }
)

map_cmd("n|<leader>o", "Lspsaga outline", { silent = true })
map_cmd("n|K", "Lspsaga hover_doc", { silent = true })

-- treesitter
require("nvim-treesitter.configs").setup({
	ensure_installed = { "c", "lua", "vim", "help", "markdown", "markdown_inline" },
	sync_install = false,
	auto_install = true,

	highlight = {
		enable = true,

		ignore_install = { "javascript" },

		-- Or use a function for more flexibility, e.g. to disable slow treesitter highlight for large files
		disable = function(lang, buf)
			local max_filesize = 100 * 1024 -- 100 KB
			local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
			if ok and stats and stats.size > max_filesize then
				return true
			end
		end,
	},
})
