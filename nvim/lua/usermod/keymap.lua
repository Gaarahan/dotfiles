local legendary = require("legendary")
local keymapList = require('usermod.keymaps.index')

legendary.setup({
  keymaps = keymapList,
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
