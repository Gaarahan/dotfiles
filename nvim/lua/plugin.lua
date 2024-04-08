local hipatternsConf = require("usermod.hipatterns")
local telescopeConf = require("usermod.telescope")
local formatterConf = require("usermod.formatter")

local plugins = {
  "dstein64/vim-startuptime",

  -- Appearance customize
  "mhinz/vim-startify", -- customize the startup page
  {
    "ellisonleao/gruvbox.nvim",
    init = function()
      require("gruvbox").setup({
        contrast = "soft",
        inverse = false,
      })
    end,
  },
  "nvim-lualine/lualine.nvim",                                                   -- status line
  { "romgrk/barbar.nvim",    dependencies = { "nvim-tree/nvim-web-devicons" } }, -- buffer line
  "yuttie/comfortable-motion.vim",                                               -- move smooth when use like <C-f>
  "stevearc/dressing.nvim",                                                      -- beautify vim.ui
  { "kevinhwang91/nvim-ufo", dependencies = { "kevinhwang91/promise-async" } },  -- improve vim fold
  hipatternsConf,                                                                -- highlight todo and colors

  --  plug for dir_tree
  { "nvim-tree/nvim-tree.lua",         dependencies = { "nvim-tree/nvim-web-devicons" } },

  -- LSP
  { "nvim-treesitter/nvim-treesitter", run = ":TSUpdate" },
  "neovim/nvim-lspconfig", -- Configurations for Nvim LSP
  {
    "nvimdev/lspsaga.nvim",
    init = function()
      require("lspsaga").setup({
        lightbulb = {
          enable = false,
        },
      })
    end,
    dependencies = {
      'nvim-treesitter/nvim-treesitter',
      'nvim-tree/nvim-web-devicons'
    },
    event = 'LspAttach'
  }, -- for lsp rename、jump in diagnostics、code action、hover doc
  {
    "williamboman/mason.nvim",
    lazy = true,
    init = function()
      require("mason").setup()
    end,
  },                                  -- install LSP servers, DAP servers, linters, and formatters
  { "j-hui/fidget.nvim", opts = {} }, -- show lsp progress

  -- Autocompletion plugin
  "hrsh7th/nvim-cmp",
  "mattn/emmet-vim",
  "hrsh7th/cmp-nvim-lsp",                                                   -- LSP source for nvim-cmp
  { "L3MON4D3/LuaSnip",  version = "v2.*", run = "make install_jsregexp" }, -- Snippets plugin
  "windwp/nvim-ts-autotag",

  -- Plug for base input
  {
    "windwp/nvim-autopairs",
    init = function()
      require("nvim-autopairs").setup({})
    end,
  },
  { "andymass/vim-matchup",    event = "VimEnter" }, -- make '%' support more feature
  "tpope/vim-surround",                              -- cs{need_replace}{target_char}
  "voldikss/vim-translator",                         -- select block and enter Translate*
  "junegunn/vim-easy-align",                         -- select block and enter 'ga[align-char]' to align by special char
  "nvim-pack/nvim-spectre",                          -- quick find and replace
  {
    "phaazon/hop.nvim",
    branch = "v2",
    init = function()
      require("hop").setup()
    end,
  },                          -- improve f t, fast moving in doc
  "phelipetls/jsonpath.nvim", -- show jsonpath when edit json
  {
    "numToStr/Comment.nvim",
    init = function()
      require("Comment").setup()
    end,
  }, -- quick comment code or remove comment

  { "lewis6991/gitsigns.nvim", dependencies = { "nvim-lua/plenary.nvim" } },
  "sindrets/diffview.nvim",

  telescopeConf,
  formatterConf,

  -- keymap manager
  "mrjones2014/legendary.nvim",

  -- lazyload
  { "nvim-treesitter/playground", lazy = true, cmd = { "TSPlaygroundToggle" } },
  {
    "iamcco/markdown-preview.nvim",
    run = "cd app && npm install",
    setup = function()
      vim.g.mkdp_filetypes = { "markdown" }
    end,
    lazy = true,
    cmd = { "MarkdownPreview" },
    ft = { "markdown" },
  },
}

require("lazy").setup(plugins)
