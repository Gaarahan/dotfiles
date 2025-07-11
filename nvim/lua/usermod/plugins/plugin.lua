local hipatternsConf = require("usermod.plugins.hipatterns")
local formatterConf = require("usermod.plugins.formatter")
local luaSnipConf = require('usermod.plugins.completion')
local lspConf = require('usermod.plugins.lsp')
local gitConf = require('usermod.plugins.git')
local snacksConf = require('usermod.plugins.snacks')

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
  "stevearc/dressing.nvim",                                                      -- beautify vim.ui
  { "kevinhwang91/nvim-ufo", dependencies = { "kevinhwang91/promise-async" } },  -- improve vim fold
  hipatternsConf,                                                                -- highlight todo and colors

  -- LSP
  lspConf,

  -- Autocompletion plugin
  luaSnipConf,
  "windwp/nvim-ts-autotag",
  {
    "mattn/emmet-vim",
    init = function()
      vim.g.user_emmet_leader_key = '<C-A>'
    end
  },

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
  {
    'heavenshell/vim-jsdoc',
    build = 'make install',
    ft = { 'javascript', 'typescript', 'typescriptreact' }
  },

  gitConf,

  snacksConf,
  formatterConf,

  -- keymap manager
  "mrjones2014/legendary.nvim",

  -- lazyload
  { "nvim-treesitter/playground", lazy = true, cmd = { "TSPlaygroundToggle" } },
  {
    "iamcco/markdown-preview.nvim",
    build = "cd app && npm install",
    config = function()
      vim.g.mkdp_filetypes = { "markdown" }
    end,
    lazy = true,
    cmd = { "MarkdownPreview" },
    ft = { "markdown" },
  },
}

require("lazy").setup(plugins)
