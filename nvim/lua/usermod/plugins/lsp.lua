return {
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    init = function()
      -- treesitter
      require("nvim-treesitter.configs").setup({
        ensure_installed = {
          "c",
          "json",
          "bash",
          "lua",
          "html",
          "vim",
          "markdown",
          "markdown_inline",
          "javascript",
          "typescript",
        },
        sync_install = false,
        auto_install = true,
        autotag = {
          enable = true,
        },
        highlight = {
          enable = true,

          -- Or use a function for more flexibility, e.g. to disable slow treesitter highlight for large files
          disable = function(lang, buf)
            local max_filesize = 30 * 1024 -- KB
            local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
            if ok and stats and stats.size > max_filesize then
              return true
            end
          end,
        },
      })
    end
  },

  { -- show current context (eg. which function、which object)
    "nvim-treesitter/nvim-treesitter-context",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    config = function()
      require("treesitter-context").setup()
    end
  },

  {
    "nvimdev/lspsaga.nvim",
    init = function()
      -- disable builtin diagnostic virtual_text
      vim.diagnostic.config({
        virtual_text = false,
      })

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
    dependencies = {
      "williamboman/mason-lspconfig.nvim",
      "neovim/nvim-lspconfig",
    },
    init = function()
      require("mason").setup();
      require("mason-lspconfig").setup({
        automatic_enable = true,
        ensure_installed = { "cssls", "css_variables", "eslint", "lua_ls", "ts_ls", "vue_ls" }
      });
    end,
  },                                  -- install LSP servers, DAP servers, linters, and formatters

  { "j-hui/fidget.nvim", opts = {} }, -- show lsp progress

  {
    'mfussenegger/nvim-lint',
    init = function()
      vim.env.ESLINT_D_PPID = vim.fn.getpid()
      require('lint').linters_by_ft = {
        javascript = { 'eslint_d' },
        typescript = { 'eslint_d' },
      }
    end
  }
}
