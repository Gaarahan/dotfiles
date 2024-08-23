local M = {
	"L3MON4D3/LuaSnip",
	version = "v2.*",
	run = "make install_jsregexp",
	dependencies = {
	  "hrsh7th/nvim-cmp",
	  "hrsh7th/cmp-nvim-lsp", -- LSP source for nvim-cmp
	  "rafamadriz/friendly-snippets",
	  "uga-rosa/cmp-dictionary",
	},
	init = function()
	  require("luasnip.loaders.from_vscode").lazy_load()
	  require("cmp_dictionary").setup({
		paths = { "/usr/share/dict/words" },
		exact_length = 2,
	  })
  
	  -- lua setup
	  local luasnip = require("luasnip")
	  local cmp = require("cmp")
	  cmp.setup({
		snippet = {
		  expand = function(args)
			luasnip.lsp_expand(args.body)
		  end,
		},
		mapping = cmp.mapping.preset.insert({
		  ["<C-d>"] = cmp.mapping.scroll_docs(-4),
		  ["<C-f>"] = cmp.mapping.scroll_docs(4),
		  ["<C-Space>"] = cmp.mapping.complete(),
		  ["<CR>"] = cmp.mapping.confirm({
			behavior = cmp.ConfirmBehavior.Replace,
			select = true,
		  }),
		  ["<Tab>"] = cmp.mapping(function(fallback)
			if cmp.visible() then
			  cmp.select_next_item()
			elseif luasnip.expand_or_jumpable() then
			  luasnip.expand_or_jump()
			else
			  fallback()
			end
		  end, { "i", "s" }),
		  ["<S-Tab>"] = cmp.mapping(function(fallback)
			if cmp.visible() then
			  cmp.select_prev_item()
			elseif luasnip.jumpable(-1) then
			  luasnip.jump(-1)
			else
			  fallback()
			end
		  end, { "i", "s" }),
		}),
		sources = {
		  { name = "nvim_lsp" },
		  { name = "luasnip" },
		  {
			name = "dictionary",
			keyword_length = 2,
		  },
		},
	  })
	end
  }
  
  return M;
  