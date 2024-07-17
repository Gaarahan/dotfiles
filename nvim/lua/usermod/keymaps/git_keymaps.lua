return {
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
}
