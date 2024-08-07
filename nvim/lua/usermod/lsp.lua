local lspconfig = require("lspconfig")

local capabilities = require("cmp_nvim_lsp").default_capabilities()
-- FIXME: To support each new language, need change this list and treesitter list
-- Enable some language servers with the additional completion capabilities offered by nvim-cmp
local servers = {
	"clangd",
	"rust_analyzer",
	"pyright",
	"tsserver",
	"html",
	"cssls",
	"stylelint_lsp",
	"eslint",
	"lua_ls",
}
for _, ls in ipairs(servers) do
	lspconfig[ls].setup({
		capabilities = capabilities,
    single_file_support = false,
	})
end

-- disable builtin diagnostic virtual_text
vim.diagnostic.config({
	virtual_text = false,
})

-- treesitter
require("nvim-treesitter.configs").setup({
	ensure_installed = {
		"c",
		"json",
		"bash",
		"lua",
		"html",
		"vim",
		"markdown",
		"markdown_inline",
		"javascript",
		"typescript",
	},
	sync_install = false,
	auto_install = true,
	autotag = {
		enable = true,
	},
	highlight = {
		enable = true,

		-- Or use a function for more flexibility, e.g. to disable slow treesitter highlight for large files
		disable = function(lang, buf)
			local max_filesize = 30 * 1024 -- KB
			local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
			if ok and stats and stats.size > max_filesize then
				return true
			end
		end,
	},
})
