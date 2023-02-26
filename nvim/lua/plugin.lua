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
	use("glepnir/oceanic-material") -- theme
	use({ "ellisonleao/gruvbox.nvim" })
	use("nvim-lualine/lualine.nvim") -- buffer line and status line
	use("romgrk/barbar.nvim")
	use("yuttie/comfortable-motion.vim") -- move smooth when use like <C-f>
	use("stevearc/dressing.nvim")

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
			require("lspsaga").setup({})
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
	use("saadparwaiz1/cmp_luasnip") -- Snippets source for nvim-cmp
	use({ "L3MON4D3/LuaSnip", version = "<CurrentMajor>.*", run = "make install_jsregexp" }) -- Snippets plugin

	-- Plug for base input
	use("jiangmiao/auto-pairs")
	use({ "andymass/vim-matchup", event = "VimEnter" }) -- make '%' support more feature
	use("tpope/vim-surround") -- cs{need_replace}{target_char}
	use("voldikss/vim-translator") -- select block and enter Translate*
	use("junegunn/vim-easy-align") -- select block and enter 'ga[align-char]' to align by special char
	use({
		"phaazon/hop.nvim",
		branch = "v2",
		config = function()
			require("hop").setup()
		end,
	})
	use({
		"echasnovski/mini.ai",
		branch = "stable",
		config = function()
			require("mini.ai").setup()
		end,
	}) -- more textobjects

	-- Plug for git
	use("kdheepak/lazygit.nvim")
	use({
		"lewis6991/gitsigns.nvim",
		requires = "nvim-lua/plenary.nvim",
	})

	use({
		"nvim-telescope/telescope.nvim",
		tag = "0.1.0",
		requires = {
			"nvim-telescope/telescope-live-grep-args.nvim",
		},
		config = function()
			require("telescope").load_extension("live_grep_args")
		end,
	})
	-- formatter
	use("mhartington/formatter.nvim")

	use({ "iamcco/markdown-preview.nvim", cmd = "cd app && yarn install", ft = { "markdown", "vim-plug" } })

	use("mrjones2014/legendary.nvim") -- keymap manager
	if packer_bootstrap then
		require("packer").sync()
	end
end)

