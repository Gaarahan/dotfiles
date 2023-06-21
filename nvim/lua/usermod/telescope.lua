local builtin_pickers = require("telescope.pickers")

local picker_config = {}
for b, _ in pairs(builtin_pickers) do
	picker_config[b] = { fname_width = 70 }
end

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
		layout_strategy = "horizontal",
		layout_config = {
			horizontal = {
				height = 0.9,
				preview_cutoff = 120,
				prompt_position = "bottom",
				width = 0.9,
			},
		},
	},
	pickers = vim.tbl_extend("force", picker_config, {
		lsp_references = { fname_width = 70, show_line = false },
		lsp_definitions = { fname_width = 70, show_line = false },
		lsp_type_definitions = { fname_width = 70, show_line = false },
		lsp_implementations = { fname_width = 70, show_line = false },
	}),
})
