local hop = require("hop")
local directions = require("hop.hint").HintDirection
local legendary = require("legendary")
local ufo = require("ufo")

-- 使用 Lua 模块级变量替代 vim.g，避免全局变量状态保存问题
local terminal_state = {
  win = nil,
  buf = nil
}

local function toggle_right_terminal_vsplit()
  -- 自动复制当前代码位置到剪贴板
  local path = vim.fn.expand("%:p")
  if path ~= "" then
    -- 获取选中区域的行号范围
    local start_line, end_line
    local mode = vim.api.nvim_get_mode().mode
    if mode == "v" or mode == "V" or mode == "\22" then
      -- 视觉模式下获取选中区域
      -- 先退出visual mode获取选中位置
      vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "nx", false)
      start_line = vim.fn.getpos("'<")[2]
      end_line = vim.fn.getpos("'>")[2]
    else
      -- 普通模式下只获取当前行
      start_line = vim.fn.line(".")
      end_line = start_line
    end

    local code_location
    if start_line == end_line then
      code_location = string.format("%s:%d", path, start_line)
    else
      code_location = string.format("%s:%d~%d", path, start_line, end_line)
    end

    vim.fn.setreg("+", code_location)
    vim.api.nvim_echo({ { ("Copied code location: " .. code_location), "None" } }, false, {})
  end

  -- 检查是否已经存在终端窗口
  local terminal_win = nil
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    local buf = vim.api.nvim_win_get_buf(win)
    if vim.bo[buf].buftype == "terminal" then
      terminal_win = win
      break
    end
  end

  if terminal_win then
    -- 如果找到终端窗口，隐藏它（不关闭，只是隐藏）
    vim.api.nvim_win_hide(terminal_win)
    terminal_state.win = nil
    return
  end

  -- 如果没有终端窗口，创建新窗口并设置尺寸
  vim.cmd("botright vsplit")
  terminal_state.win = vim.api.nvim_get_current_win()
  local total_width = vim.api.nvim_get_option("columns")
  local terminal_width = math.floor(total_width * 0.4)
  vim.api.nvim_win_set_width(terminal_state.win, terminal_width)

  -- 检查是否有已隐藏的终端缓冲区，否则创建新的
  if terminal_state.buf and vim.api.nvim_buf_is_valid(terminal_state.buf) and vim.bo[terminal_state.buf].buftype == "terminal" then
    vim.api.nvim_set_current_buf(terminal_state.buf)
  else
    -- 创建新的终端时，指定要自动执行的命令
    local auto_command = "traecli"
    vim.cmd("terminal " .. auto_command)
    terminal_state.buf = vim.api.nvim_get_current_buf()
    vim.bo[terminal_state.buf].bufhidden = "hide"
    vim.bo[terminal_state.buf].swapfile = false
  end

  vim.cmd("startinsert")
end

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
    {
      "<C-t>",
      toggle_right_terminal_vsplit,
      description = "Toggle right terminal (vsplit) - Press C-t",
      mode = { "n", "t", "v" },
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
    {
      "gf",
      function()
        local api = require("nvim-tree.api")
        local node = api.tree.get_node_under_cursor()
        if not node then
          return
        end

        local path = node.absolute_path
        if node.type ~= "directory" then
          path = vim.fn.fnamemodify(path, ":h")
        end

        require("usermod.telescopePickers").prettyGrepPicker({
          picker = "live_grep",
          options = {
            search_dirs = { path },
            prompt_title = "Search in " .. vim.fn.fnamemodify(path, ":t"),
          },
        })
      end,
      description = "Grep folder(in nvim-tree)",
      filters = { ft = "NvimTree" },
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
    },
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
