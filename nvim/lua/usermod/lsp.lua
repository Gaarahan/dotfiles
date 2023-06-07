local lspconfig = require("lspconfig")

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.foldingRange = {
	dynamicRegistration = false,
	lineFoldingOnly = true,
}
-- FIXME: To support each new language, need change this list and treesitter list
-- Enable some language servers with the additional completion capabilities offered by nvim-cmp
local servers = {
	"clangd",
	"rust_analyzer",
	"pyright",
	"tsserver",
	"cssls",
	"stylelint_lsp",
	"eslint",
	"lua_ls",
}
for _, ls in ipairs(servers) do
	lspconfig[ls].setup({
		capabilities = capabilities,
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
		"vim",
		"markdown",
		"markdown_inline",
		"javascript",
		"typescript",
	},
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
