local hop = require("hop")
local directions = require("hop.hint").HintDirection
local ufo = require("ufo")

return {
  {
    "<leader>ya",
    "ggVGy",
    description = 'Copy all document'
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
    "gw",
    ":HopWord<CR>",
    description = "Go to word",
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
  }
}