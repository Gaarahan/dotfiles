local hop = require("hop")
local directions = require("hop.hint").HintDirection
local legendary = require("legendary")
local ufo = require("ufo")

legendary.setup({
  keymaps = {
    {
      "<leader>fb",
      function()
        require("telescope.builtin").current_buffer_fuzzy_find()
      end,
      description = "Find string in current buffer",
    },
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
      "ga",
      "<Plug>(EasyAlign)",
      description = "Start interactive EasyAlign in visual mode (e.g. vipga)",
      mode = { "x" },
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
      ":Guard fmt<CR>",
      description = "Format current doc",
    },
    {
      "<leader>fe",
      ":EslintFixAll<CR>",
      description = "Fix all eslint issue",
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
      function()
        require("telescope.builtin").buffers()
      end,
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
      "gw",
      ":HopWord<CR>",
      description = "Go to word",
    },
    {
      "K",
      ":Lspsaga hover_doc<CR>",
      description = "Show document",
    },
    {
      "[E",
      ":Lspsaga diagnostic_jump_prev<CR>",
      description = "Go to previous diagnostic",
    },
    {
      "]E",
      ":Lspsaga diagnostic_jump_next<CR>",
      description = "Go to next diagnostic",
    },
    {
      "[e",
      function()
        require("lspsaga.diagnostic"):goto_prev({ severity = vim.diagnostic.severity.ERROR })
      end,
      description = "Go to previous error",
    },
    {
      "]e",
      function()
        require("lspsaga.diagnostic"):goto_next({ severity = vim.diagnostic.severity.ERROR })
      end,
      description = "Go to next error",
    },
    {
      "[q",
      ":cp<CR>",
      description = "Go to previous quickfix",
    },
    {
      "]q",
      ":cn<CR>",
      description = "Go to next quickfix",
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
    {
      "<leader>dh",
      ":DiffviewFileHistory %<CR>",
      description = "Show git history of current buffer",
    },
    {
      "<leader>dc",
      ":DiffviewClose<CR>",
      description = "Close git diffview",
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
        require("usermod.telescopePickers").prettyFilesPicker({ picker = "find_files" })
      end,
      description = "Find file name",
    },
    {
      "<leader>fs",
      ":Telescope lsp_document_symbols<CR>",
      description = "Find symbols in current file",
    },
    {
      "<leader>fg",
      function()
        require("usermod.telescopePickers").prettyGrepPicker({
          picker = "live_grep",
          options = {
            disable_coordinates = true,
          },
        })
      end,
      description = "Find string (Ctrl-k:Case, Ctrl-l:Word, Ctrl-r:Regex)",
    },
    {
      "<leader>fi",
      ":Telescope dir live_grep<CR>",
      description = "Find string in special dir",
    },
    {
      "<leader>fr",
      function()
        require("telescope.builtin").resume()
      end,
      description = "Resume previous find",
    },
    {
      "<leader>fh",
      function()
        require("telescope.builtin").help_tags()
      end,
      description = "Find string in help page",
    },
    {
      '<leader>s',
      function()
        require('spectre').toggle();
      end,
      description = 'Find and Replace text'
    },
    {
      "gc",
      description = "Comment with line-comment",
    },
    {
      "gb",
      description = "Comment with block-comment",
    },
    {
      "<leader>yp",
      function()
        vim.fn.setreg("+", require("jsonpath").get())
      end,
      description = "Copy json path",
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
    {
      "zR",
      function()
        ufo.openAllFolds()
      end,
      hide = true,
    },
    {
      "zM",
      function()
        ufo.closeAllFolds()
      end,
      hide = true,
    },
    {
      "zk",
      function()
        ufo.goPreviousClosedFold()
      end,
      description = "Go to prev closed fold",
    },
    {
      "zj",
      function()
        ufo.goNextClosedFold()
      end,
      description = "Go to next closed flod",
    },
    {
      "<leader>ya",
      "ggVGy",
      description = 'Copy all document'
    }
    ,
    {
      "<C-g>",
      function()
        local path = vim.fn.expand("%:p")
        if path == "" then
          path = vim.fn.expand("%")
        end
        vim.fn.setreg("+", path)
        vim.api.nvim_echo({ { ("Copied path: " .. path), "None" } }, false, {})
      end,
      description = "Show and copy current file path",
    }
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
  autocmds = {
    {
      "BufEnter",
      function()
        if vim.fn.exists("+winbar") == 1 then
          vim.opt_local.winbar = "%{%v:lua.require'jsonpath'.get()%}"
        end
      end,
      description = "Add JSON path in winbar",
      opts = {
        pattern = { "*.json" },
      },
    },
    {
      "BufEnter",
      function()
        vim.opt.formatoptions:remove("c")
        vim.opt.formatoptions:remove("o")
      end,
      description = "Don't automatically add comment",
      opts = {
        pattern = { "*" },
      },
    },
    {
      "FileType",
      "wincmd H",
      description = "Always open help file in vertical split",
      opts = {
        pattern = { "help" }
      }
    }
  },
  -- Customize the prompt that appears on your vim.ui.select() handler
  -- Can be a string or a function that returns a string.
  select_prompt = "Find Command",
  include_builtin = false,
  include_legendary_cmds = false,
})
