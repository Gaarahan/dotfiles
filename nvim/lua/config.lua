-- { Load module: }"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

local conf_modules = {
	"plugins.plugin", -- init plugin

	-- config ---
	"basic",
	"keymap",
	"appearance",
	"lsp",
	"nvimtree",
	"gitsigns",
	"nvim-ufo",
}

for i = 1, #conf_modules do
	local modulePath = "./usermod." .. conf_modules[i]
	require(modulePath)
end
