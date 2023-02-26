local utils = require("usermod.utils")
local map = utils.map
local map_cmd = utils.map_cmd
local lua_fn = utils.lua_fn

-- disable builtin diagnostic virtual_text
vim.diagnostic.config({
	virtual_text = false,
})

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
