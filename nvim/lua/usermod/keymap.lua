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
  -- 自动复制当前代码位置到剪贴板（终端窗口内触发时跳过）
  local cur_buf = vim.api.nvim_get_current_buf()
  local is_terminal_buf = vim.bo[cur_buf].buftype == "terminal"
  if not is_terminal_buf then
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
      description = "Find string in current buffer - [nvim-telescope/telescope.nvim]",
    },
    {
      "<leader>fc",
      ":Legendary<CR>",
      description = "Find Command - [mrjones2014/legendary.nvim]",
    },
    {
      "<leader>sv",
      ":source $MYVIMRC<CR>",
      description = "Source vim configuration",
    },
    {
      "ga",
      "<Plug>(EasyAlign)",
      description = "Start interactive EasyAlign in visual mode (e.g. vipga) - [junegunn/vim-easy-align]",
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
      description = "Open mason - LSP manager - [mason-org/mason.nvim]",
    },
    {
      "<leader>fd",
      ":Guard fmt<CR>",
      description = "Format current doc - [nvimdev/guard.nvim]",
    },
    {
      "<leader>fe",
      ":EslintFixAll<CR>",
      description = "Fix all eslint issue",
    },
    {
      "<leader>[",
      ":BufferPrevious<CR>",
      description = "Move to previous buffer - [romgrk/barbar.nvim]",
    },
    {
      "<leader>]",
      ":BufferNext<CR>",
      description = "Move to next buffer - [romgrk/barbar.nvim]",
    },
    {
      "<leader>dd",
      ":BufferClose<CR>",
      description = "Close current buffer - [romgrk/barbar.nvim]",
    },
    {
      "<leader>bo",
      ":BufferCloseAllButCurrent<CR>",
      description = "Close all but current buffer - [romgrk/barbar.nvim]",
    },
    {
      "<leader>bd",
      ":BufferOrderByDirectory<CR>",
      description = "Buffer order by dir - [romgrk/barbar.nvim]",
    },
    {
      "<C-p>",
      function()
        require("telescope.builtin").buffers()
      end,
      description = "Pick special buffer - [nvim-telescope/telescope.nvim]",
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
      description = "Show code action - [nvimdev/lspsaga.nvim]",
    },
    {
      "<leader>rn",
      ":Lspsaga rename<CR>",
      description = "Rename current symbol - [nvimdev/lspsaga.nvim]",
    },
    {
      "<leader>ld",
      ":Lspsaga show_line_diagnostics<CR>",
      description = "Show current line diagnostics - [nvimdev/lspsaga.nvim]",
    },
    {
      "<leader>lc",
      ":Lspsaga show_cursor_diagnostics<CR>",
      description = "Show current cursor diagnostics - [nvimdev/lspsaga.nvim]",
    },
    {
      "gi",
      ":Telescope lsp_implementations<CR>",
      description = "Go to implementations - [nvim-telescope/telescope.nvim]",
    },
    {
      "gr",
      ":Telescope lsp_references<CR>",
      description = "Go to references - [nvim-telescope/telescope.nvim]",
    },
    {
      "gd",
      ":Telescope lsp_definitions<CR>",
      description = "Go to definition - [nvim-telescope/telescope.nvim]",
    },
    {
      "gw",
      ":HopWord<CR>",
      description = "Go to word - [phaazon/hop.nvim]",
    },
    {
      "K",
      ":Lspsaga hover_doc<CR>",
      description = "Show document - [nvimdev/lspsaga.nvim]",
    },
    {
      "[E",
      ":Lspsaga diagnostic_jump_prev<CR>",
      description = "Go to previous diagnostic - [nvimdev/lspsaga.nvim]",
    },
    {
      "]E",
      ":Lspsaga diagnostic_jump_next<CR>",
      description = "Go to next diagnostic - [nvimdev/lspsaga.nvim]",
    },
    {
      "[e",
      function()
        require("lspsaga.diagnostic"):goto_prev({ severity = vim.diagnostic.severity.ERROR })
      end,
      description = "Go to previous error - [nvimdev/lspsaga.nvim]",
    },
    {
      "]e",
      function()
        require("lspsaga.diagnostic"):goto_next({ severity = vim.diagnostic.severity.ERROR })
      end,
      description = "Go to next error - [nvimdev/lspsaga.nvim]",
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
      description = "Go to next diff hunk - [lewis6991/gitsigns.nvim]",
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
      description = "Go to previous diff hunk - [lewis6991/gitsigns.nvim]",
    },
    {
      "<leader>tb",
      function()
        local gs = package.loaded.gitsigns
        gs.toggle_current_line_blame()
      end,
      description = "Toggle current line git blame - [lewis6991/gitsigns.nvim]",
    },
    {
      "<leader>dh",
      ":DiffviewFileHistory %<CR>",
      description = "Show git history of current buffer - [sindrets/diffview.nvim]",
    },
    {
      "<leader>dc",
      ":DiffviewClose<CR>",
      description = "Close git diffview - [sindrets/diffview.nvim]",
    },

    -- file explorer --
    {
      "<F3>",
      ":NvimTreeToggle<CR>",
      description = "Toggle file explorer - [nvim-tree/nvim-tree.lua]",
    },
    {
      "<F4>",
      ":NvimTreeFindFileToggle<CR>",
      description = "Open current file in explorer - [nvim-tree/nvim-tree.lua]",
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
      description = "Grep folder(in nvim-tree) - [nvim-tree/nvim-tree.lua + nvim-telescope/telescope.nvim]",
      filters = { ft = "NvimTree" },
    },
    -- searcher --
    {
      "<leader>ff",
      function()
        require("usermod.telescopePickers").prettyFilesPicker({ picker = "find_files" })
      end,
      description = "Find file name - [nvim-telescope/telescope.nvim]",
    },
    {
      "<leader>fs",
      ":Telescope lsp_document_symbols<CR>",
      description = "Find symbols in current file - [nvim-telescope/telescope.nvim]",
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
      description = "Find string (Ctrl-k:Case, Ctrl-l:Word, Ctrl-r:Regex) - [nvim-telescope/telescope.nvim]",
    },
    {
      "<leader>fi",
      ":Telescope dir live_grep<CR>",
      description = "Find string in special dir - [nvim-telescope/telescope.nvim]",
    },
    {
      "<leader>fr",
      function()
        require("telescope.builtin").resume()
      end,
      description = "Resume previous find - [nvim-telescope/telescope.nvim]",
    },
    {
      "<leader>fh",
      function()
        require("telescope.builtin").help_tags()
      end,
      description = "Find string in help page - [nvim-telescope/telescope.nvim]",
    },
    {
      '<leader>s',
      function()
        require('spectre').toggle();
      end,
      description = 'Find and Replace text - [nvim-pack/nvim-spectre]'
    },
    {
      "gc",
      description = "Comment with line-comment - [numToStr/Comment.nvim]",
    },
    {
      "gb",
      description = "Comment with block-comment - [numToStr/Comment.nvim]",
    },
    {
      "<leader>yp",
      function()
        vim.fn.setreg("+", require("jsonpath").get())
      end,
      description = "Copy json path - [phelipetls/jsonpath.nvim]",
    },
    -- hidden --
    {
      "f",
      function()
        hop.hint_char1({ direction = directions.AFTER_CURSOR, current_line_only = true })
      end,
      description = "Find char forward - [phaazon/hop.nvim]",
      hide = true,
    },
    {
      "F",
      function()
        hop.hint_char1({ direction = directions.BEFORE_CURSOR, current_line_only = true })
      end,
      description = "Find char forward - [phaazon/hop.nvim]",
      hide = true,
    },
    {
      "t",
      function()
        hop.hint_char1({ direction = directions.AFTER_CURSOR, current_line_only = true, hint_offset = -1 })
      end,
      description = "Find char forward - [phaazon/hop.nvim]",
      hide = true,
    },
    {
      "T",
      function()
        hop.hint_char1({ direction = directions.BEFORE_CURSOR, current_line_only = true, hint_offset = 1 })
      end,
      description = "Find char forward - [phaazon/hop.nvim]",
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
      description = "Open all folds - [kevinhwang91/nvim-ufo]",
      hide = true,
    },
    {
      "zM",
      function()
        ufo.closeAllFolds()
      end,
      description = "Close all folds - [kevinhwang91/nvim-ufo]",
      hide = true,
    },
    {
      "zk",
      function()
        ufo.goPreviousClosedFold()
      end,
      description = "Go to prev closed fold - [kevinhwang91/nvim-ufo]",
    },
    {
      "zj",
      function()
        ufo.goNextClosedFold()
      end,
      description = "Go to next closed flod - [kevinhwang91/nvim-ufo]",
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
      description = "Open markdown preview - [iamcco/markdown-preview.nvim]",
    },
    {
      ":MarkdownPreviewStop",
      description = "Close markdown preview - [iamcco/markdown-preview.nvim]",
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
      description = "Add JSON path in winbar - [phelipetls/jsonpath.nvim]",
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
    },
    {
      "BufEnter",
      function()
        local file = vim.fn.expand("%:p")
        if file == "" then
          return
        end
        vim.cmd("silent! !open " .. vim.fn.shellescape(file))
        vim.cmd("bw")
      end,
      description = "Open image file externally and close buffer",
      opts = {
        pattern = { "*.png", "*.jpg", "*.gif" },
      },
    },
    {
      "TermOpen",
      function()
        -- Terminal buffers are not natural-language text, so spell-checking there
        -- tends to underline almost everything (including Chinese). Disable it.
        vim.opt_local.spell = false
      end,
      description = "Disable spell in terminal buffers",
    },
    {
      "TermEnter",
      function()
        vim.opt_local.spell = false
      end,
      description = "Disable spell in terminal buffers (enter)",
    },
    {
      "BufEnter",
      function()
        vim.opt_local.spell = false
      end,
      description = "Disable spell in terminal buffers (term://*)",
      opts = {
        pattern = { "term://*" },
      },
    }
  },
  -- Customize the prompt that appears on your vim.ui.select() handler
  -- Can be a string or a function that returns a string.
  select_prompt = "Find Command",
  include_builtin = false,
  include_legendary_cmds = false,
})
