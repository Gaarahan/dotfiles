local hop = require("hop")
local directions = require("hop.hint").HintDirection
local legendary = require("legendary")
local ufo = require("ufo")


legendary.setup({
  keymaps = {
    {
      "<leader>fb",
      function()
        Snacks.picker.grep_buffers()
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
        Snacks.picker.buffers()
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
    { "gi", function() Snacks.picker.lsp_implementations() end, description = "Go to implementations" },
    { "gr", function() Snacks.picker.lsp_references() end,      description = "Go to references" },
    { "gd", function() Snacks.picker.lsp_definitions() end,     description = "Go to definition" },
    { "gD", function() Snacks.picker.lsp_declarations() end,    description = "Go to declarations" },
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

    { "[q", ":cp<CR>",      description = "Go to previous quickfix" },
    { "]q", ":cn<CR>",      description = "Go to next quickfix" },

    -- base input
    { "gw", ":HopWord<CR>", description = "Go to word" },

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
      "<leader>lg",
      ":LazyGit<CR>",
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
      function()
        Snacks.explorer.open()
      end,
      description = "Toggle file explorer",
    },
    -- searcher --
    {
      "<leader>ff",
      function()
        Snacks.picker.git_files()
      end,
      description = "Find file name",
    },
    {
      "<leader>fs",
      function()
        Snacks.picker.lsp_symbols()
      end,
      description = "Find symbols in current file",
    },
    {
      "<leader>fg",
      function()
        Snacks.picker.grep()
      end,
      description = "Find string in workspace",
    },
    {
      "<leader>fi",
      function()
        Snacks.picker.files()
      end,
      description = "Find in all files",
    },
    {
      "<leader>fr",
      function()
        Snacks.picker.resume()
      end,
      description = "Resume previous find",
    },
    {
      "<leader>fh",
      function()
        Snacks.picker.help()
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
      "<leader>ya",
      "ggVGy",
      description = 'Copy all document'
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
  },
  -- Customize the prompt that appears on your vim.ui.select() handler
  -- Can be a string or a function that returns a string.
  select_prompt = "Find Command",
  include_builtin = false,
  include_legendary_cmds = false,
})
