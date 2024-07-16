return {
  {
    "<leader>ms",
    ":Mason<CR>",
    description = "Open mason - LSP manager",
  },
  {
    "<leader>fd",
    ":GuardFmt<CR>",
    description = "Format current doc",
  },
  {
    "<leader>fe",
    ":EslintFixAll<CR>",
    description = "Fix all eslint issue",
  },
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
}