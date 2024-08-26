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
      require("mason-lspconfig").setup();
      require("mason-lspconfig").setup_handlers {
        function(server_name) -- default handler (optional)
          local capabilities = require("cmp_nvim_lsp").default_capabilities()
          require("lspconfig")[server_name].setup {
            capabilities = capabilities,
            single_file_support = false,
          }
        end,
        -- Next, you can provide a dedicated handler for specific servers.
        -- For example, a handler override for the `rust_analyzer`:
        ["rust_analyzer"] = function()
          require("rust-tools").setup {}
        end
      }
    end,
  }, -- install LSP servers, DAP servers, linters, and formatters
  { "j-hui/fidget.nvim",    opts = {} }, -- show lsp progress
}
