-- { Load module: }"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

local conf_modules = {
	"basic",
	"keymap",
	"appearance",
	"lsp",
	"nvimtree",
	"gitsigns",
	"telescope",
	"completion",
	"formatter",
	"nvim-ufo",
}

for i = 1, #conf_modules do
	local modulePath = "./usermod." .. conf_modules[i]
	require(modulePath)
end
