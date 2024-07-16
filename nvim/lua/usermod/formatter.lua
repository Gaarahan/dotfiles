return {
  "nvimdev/guard.nvim",
  dependencies = {
    "nvimdev/guard-collection",
  },
  init = function()
    local ft = require('guard.filetype')

    ft('typescript,javascript,typescriptreact,json,markdown'):fmt('prettier')
    require("guard").setup({
      fmt_on_save = false,
      lsp_as_default_formatter = true,
    })
  end,
}
