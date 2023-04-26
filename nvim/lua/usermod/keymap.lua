local utils = require("usermod.utils")
local map = utils.map
local map_cmd = utils.map_cmd
local lua_fn = utils.lua_fn
local hop = require("hop")
local directions = require("hop.hint").HintDirection
local legendary = require("legendary")

legendary.setup({
	keymaps = {
		{
			"<leader>fc",
			":Legendary<CR>",
			description = "Find Command",
		},
		{
			"<leader>sv",
			":source $MYVIMRC<CR>",
			description = "Source vim configuration",
		},
		{
			"<leader>lg",
			":LazyGit<CR>",
			description = "Lazy Git",
		},
		{
			"<leader>d",
			":DogeGenerate<CR>",
			description = "Generate doc",
		},
		{
			"ga",
			"<Plug>(EasyAlign)",
			description = "Start interactive EasyAlign in visual mode (e.g. vipga)",
			mode = { "x" },
		},
		{
			"<leader>fp",
			":Farr<CR>",
			description = "Quick find and replace, t to toggle exclude and s to replace",
			mode = { "n", "x" },
		},
		{
			"<leader>cl",
			":noh<CR>",
			description = "Clear highlight",
		},
		{
			"<leader>ms",
			":Mason<CR>",
			description = "Open mason - LSP manager",
		},
		{
			"<leader>fd",
			":Format<CR>",
			description = "Format current doc",
		},
		{
			"<leader>[",
			":BufferPrevious<CR>",
			description = "Move to previous buffer",
		},
		{
			"<leader>]",
			":BufferNext<CR>",
			description = "Move to next buffer",
		},
		{
			"<leader>dd",
			":BufferClose<CR>",
			description = "Close current buffer",
		},
		{
			"<leader>bo",
			":BufferCloseAllButCurrent<CR>",
			description = "Close all but current buffer",
		},
		{
			"<leader>bd",
			":BufferOrderByDirectory<CR>",
			description = "Buffer order by dir",
		},
		{
			"<C-p>",
			":BufferPick<CR>",
			description = "Pick special buffer",
		},

		-- lsp --
		{
			"<leader>ac",
			":Lspsaga code_action<CR>",
			description = "Show code action",
		},
		{
			"<leader>rn",
			":Lspsaga rename<CR>",
			description = "Rename current symbol",
		},
		{
			"<leader>ld",
			":Lspsaga show_line_diagnostics<CR>",
			description = "Show current line diagnostics",
		},
		{
			"<leader>lc",
			":Lspsaga show_cursor_diagnostics<CR>",
			description = "Show current cursor diagnostics",
		},
		{
			"gi",
			":Telescope lsp_implementations<CR>",
			description = "Go to implementations",
		},
		{
			"gr",
			":Telescope lsp_references<CR>",
			description = "Go to references",
		},
		{
			"gd",
			":Telescope lsp_definitions<CR>",
			description = "Go to definition",
		},
		{
			"<leader>o",
			":Lspsaga outline<CR>",
			description = "Show outline",
		},
		{
			"K",
			":Lspsaga hover_doc<CR>",
			description = "Show document",
		},
		{
			"[e",
			":Lspsaga diagnostic_jump_prev<CR>",
			description = "Go to previous diagnostic",
		},
		{
			"]e",
			":Lspsaga diagnostic_jump_next<CR>",
			description = "Go to next diagnostic",
		},
		{
			"[E",
			function()
				require("lspsaga.diagnostic"):goto_prev({ severity = vim.diagnostic.severity.ERROR })
			end,
			description = "Go to previous error",
		},
		{
			"]E",
			function()
				require("lspsaga.diagnostic"):goto_next({ severity = vim.diagnostic.severity.ERROR })
			end,
			description = "Go to next error",
		},

		-- git --
		{
			"]c",
			function()
				local gs = package.loaded.gitsigns
				if vim.wo.diff then
					return "]c"
				end
				vim.schedule(function()
					gs.next_hunk()
				end)
				return "<Ignore>"
			end,
			description = "Go to next diff hunk",
		},
		{
			"[c",
			function()
				local gs = package.loaded.gitsigns
				if vim.wo.diff then
					return "[c"
				end
				vim.schedule(function()
					gs.prev_hunk()
				end)
				return "<Ignore>"
			end,
			description = "Go to previous diff hunk",
		},
		{
			"<leader>tb",
			function()
				local gs = package.loaded.gitsigns
				gs.toggle_current_line_blame()
			end,
			description = "Toggle current line git blame",
		},

		-- file explorer --
		{
			"<F3>",
			":NvimTreeToggle<CR>",
			description = "Toggle file explorer",
		},
		{
			"<F4>",
			":NvimTreeFindFileToggle<CR>",
			description = "Open current file in explorer",
		},
		-- searcher --
		{
			"<leader>ff",
			function()
				require("telescope.builtin").find_files()
			end,
			description = "Find file name",
		},
		{
			"<leader>fg",
			function()
				require("telescope").extensions.live_grep_args.live_grep_args()
			end,
			description = "Find string in workspace",
		},
		{
			"<leader>fr",
			function()
				require("telescope.builtin").resume()
			end,
			description = "Resume previous find",
		},
		{
			"<leader>fb",
			function()
				require("telescope.builtin").current_buffer_fuzzy_find()
			end,
			description = "Find string in current buffer",
		},
		{
			"<leader>fh",
			function()
				require("telescope.builtin").help_tags()
			end,
			description = "Find string in help page",
		},
		-- hidden --
		{
			"f",
			function()
				hop.hint_char1({ direction = directions.AFTER_CURSOR, current_line_only = true })
			end,
			description = "Find char forward",
			hide = true,
		},
		{
			"F",
			function()
				hop.hint_char1({ direction = directions.BEFORE_CURSOR, current_line_only = true })
			end,
			description = "Find char forward",
			hide = true,
		},
		{
			"t",
			function()
				hop.hint_char1({ direction = directions.AFTER_CURSOR, current_line_only = true, hint_offset = -1 })
			end,
			description = "Find char forward",
			hide = true,
		},
		{
			"T",
			function()
				hop.hint_char1({ direction = directions.BEFORE_CURSOR, current_line_only = true, hint_offset = 1 })
			end,
			description = "Find char forward",
			hide = true,
		},
		{
			"p",
			'"_s<C-r>"<esc>',
			mode = { "v" },
			description = "Map p to not replace the default register",
			hide = true,
		},
	},
	commands = {
		{
			":MarkdownPreview",
			description = "Open markdown preview",
		},
		{
			":MarkdownPreviewStop",
			description = "Close markdown preview",
		},
	},
	-- Customize the prompt that appears on your vim.ui.select() handler
	-- Can be a string or a function that returns a string.
	select_prompt = "Find Command",
	include_builtin = false,
	include_legendary_cmds = false,
})
