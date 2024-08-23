local M = {
	"nvim-telescope/telescope.nvim",
	branch = "0.1.x",
	lazy = true,
	dependencies = { "princejoogie/dir-telescope.nvim" },
	init = function()
		local telescope = require("telescope")

		-- change picker width
		local builtin_pickers = require("telescope.pickers")

		local picker_config = {}
		for b, _ in pairs(builtin_pickers) do
			picker_config[b] = { fname_width = 70 }
		end

		telescope.setup({
			defaults = {
				-- use ripgrep as default grep engine
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
				path_display = { "smart" },
			},
			pickers = vim.tbl_extend("force", picker_config, {
				lsp_references = { fname_width = 70, show_line = false },
				lsp_definitions = { fname_width = 70, show_line = false },
				lsp_type_definitions = { fname_width = 70, show_line = false },
				lsp_implementations = { fname_width = 70, show_line = false },
			}),
		})

		-- load dir grep
		require("dir-telescope").setup({
			hidden = false,
			no_ignore = false,
			show_preview = true,
		})
	end,
}

return M
