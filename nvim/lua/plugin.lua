local ensure_packer = function()
	local fn = vim.fn
	local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
	if fn.empty(fn.glob(install_path)) > 0 then
		fn.system({ "git", "clone", "--depth", "1", "https://github.com/wbthomason/packer.nvim", install_path })
		vim.cmd([[packadd packer.nvim]])
		return true
	end
	return false
end

local packer_bootstrap = ensure_packer()
local packer = require("packer")
local use = packer.use

packer.startup(function()
	use("wbthomason/packer.nvim") -- Package manager

	-- Appearance customize
	use("mhinz/vim-startify") -- customize the startup page
	use({ "ellisonleao/gruvbox.nvim" })
	use("nvim-lualine/lualine.nvim") -- buffer line and status line
	use({ "romgrk/barbar.nvim" })
	use("yuttie/comfortable-motion.vim") -- move smooth when use like <C-f>
	use("stevearc/dressing.nvim")
	use({ "kevinhwang91/nvim-ufo", requires = "kevinhwang91/promise-async" })

	--  plug for dir_tree
	use({
		"nvim-tree/nvim-tree.lua",
		requires = {
			"nvim-tree/nvim-web-devicons",
		},
	})

	-- LSP
	use({
		"nvim-treesitter/nvim-treesitter",
		run = ":TSUpdate",
	})
	use("neovim/nvim-lspconfig") -- Configurations for Nvim LSP
	use({
		"glepnir/lspsaga.nvim",
		branch = "main",
		config = function()
			require("lspsaga").setup({
				lightbulb = {
					enable = false,
				},
			})
		end,
	})
	use({
		"williamboman/mason.nvim",
		config = function()
			require("mason").setup()
		end,
	}) -- install LSP servers, DAP servers, linters, and formatters
	use("hrsh7th/nvim-cmp") -- Autocompletion plugin
	use("hrsh7th/cmp-nvim-lsp") -- LSP source for nvim-cmp
	use({ "L3MON4D3/LuaSnip", version = "<CurrentMajor>.*", run = "make install_jsregexp" }) -- Snippets plugin
	use({
		"j-hui/fidget.nvim",
		config = function()
			require("fidget").setup({
				text = {
					spinner = "dots",
				},
			})
		end,
	})

	use({ -- Generate jsdoc
		"kkoomen/vim-doge",
		run = ":call doge#install()",
		config = function()
			vim.g.doge_javascript_settings = {
				omit_redundant_param_types = 1,
			}
		end,
	})

	-- Plug for base input
	use("jiangmiao/auto-pairs")
	use({ "andymass/vim-matchup", event = "VimEnter" }) -- make '%' support more feature
	use("tpope/vim-surround") -- cs{need_replace}{target_char}
	use("voldikss/vim-translator") -- select block and enter Translate*
	use("junegunn/vim-easy-align") -- select block and enter 'ga[align-char]' to align by special char
	use("brooth/far.vim") -- quick find and replace
	-- auto switch input method
	use({
		"rlue/vim-barbaric",
		config = function()
			vim.g.barbaric_ime = "macos"
		end,
	})
	use({
		"phaazon/hop.nvim",
		branch = "v2",
		config = function()
			require("hop").setup()
		end,
	})
	use("phelipetls/jsonpath.nvim")
	use({
		"numToStr/Comment.nvim",
		config = function()
			require("Comment").setup()
		end,
	})

	-- Plug for git
	use("kdheepak/lazygit.nvim")
	use({
		"lewis6991/gitsigns.nvim",
		requires = "nvim-lua/plenary.nvim",
	})

	-- telescope
	use({
		"nvim-telescope/telescope.nvim",
		tag = "0.1.1",
		requires = {
			"nvim-telescope/telescope-live-grep-args.nvim",
		},
		config = function()
			require("telescope").load_extension("live_grep_args")
		end,
	})
	use({
		"princejoogie/dir-telescope.nvim",
		requires = { "nvim-telescope/telescope.nvim" },
		config = function()
			require("dir-telescope").setup({
				hidden = false,
				no_ignore = false,
				show_preview = true,
			})
		end,
	})
	-- formatter
	use("mhartington/formatter.nvim")

	-- keymap manager
	use("mrjones2014/legendary.nvim")

	-- lazyload
	use({ "nvim-treesitter/playground", opt = true, cmd = { "TSPlaygroundToggle" } })
	use({
		"iamcco/markdown-preview.nvim",
		run = "cd app && npm install",
		setup = function()
			vim.g.mkdp_filetypes = { "markdown" }
		end,
		opt = true,
		cmd = { "MarkdownPreview" },
		ft = { "markdown" },
	})

	if packer_bootstrap then
		require("packer").sync()
	end
end)
