return {
  "folke/snacks.nvim",
  priority = 1000,
  lazy = false,
  ---@type snacks.Config
  opts = {
    dashboard = { enabled = false },

    bigfile = { enabled = true },
    scroll = { enabled = true }, -- move smooth when use like <C-f>
    indent = { enabled = true },
    input = { enabled = true },
    explorer = { enabled = true },
    notifier = {
      enabled = true,
      timeout = 3000,
    },
    picker = { enabled = true },
    quickfile = { enabled = true },
    scope = { enabled = true },
    statuscolumn = { enabled = true },
    words = { enabled = true },
  }
}
