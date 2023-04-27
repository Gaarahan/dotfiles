-- disable builtin diagnostic virtual_text
vim.diagnostic.config({
	virtual_text = false,
})

-- treesitter
require("nvim-treesitter.configs").setup({
	ensure_installed = { "c", "json", "bash", "lua", "vim", "markdown", "markdown_inline", "javascript", "typescript" },
	sync_install = false,
	auto_install = true,

	highlight = {
		enable = true,

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
