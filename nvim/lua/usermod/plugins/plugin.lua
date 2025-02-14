local hipatternsConf = require("usermod.plugins.hipatterns")
local telescopeConf = require("usermod.plugins.telescope")
local formatterConf = require("usermod.plugins.formatter")
local luaSnipConf = require('usermod.plugins.completion')
local lspConf = require('usermod.plugins.lsp')
local gitConf = require('usermod.plugins.git')

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
  { "nvim-tree/nvim-tree.lua", dependencies = { "nvim-tree/nvim-web-devicons" } },

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
    "johmsalas/text-case.nvim",
    dependencies = { "nvim-telescope/telescope.nvim" },
    config = function()
      require("textcase").setup({})
      require("telescope").load_extension("textcase")
    end,
    keys = {
      "ga", -- Default invocation prefix
      { "ga.", "<cmd>TextCaseOpenTelescope<CR>", mode = { "n", "x" }, desc = "Telescope" },
    },
    cmd = {
      -- NOTE: The Subs command name can be customized via the option "substitude_command_name"
      "Subs",
      "TextCaseOpenTelescope",
      "TextCaseOpenTelescopeQuickChange",
      "TextCaseOpenTelescopeLSPChange",
      "TextCaseStartReplacingCommand",
    },
    -- If you want to use the interactive feature of the `Subs` command right away, text-case.nvim
    -- has to be loaded on startup. Otherwise, the interactive feature of the `Subs` will only be
    -- available after the first executing of it or after a keymap of text-case.nvim has been used.
    lazy = false,
  },
  {
    'heavenshell/vim-jsdoc',
    build = 'make install',
    ft = { 'javascript', 'typescript', 'typescriptreact' }
  },

  gitConf,

  "RRethy/vim-illuminate", -- automate highlight words

  telescopeConf,
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
