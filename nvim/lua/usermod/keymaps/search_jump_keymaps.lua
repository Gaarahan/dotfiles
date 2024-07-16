return {
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
    "<leader>fb",
    function()
      require("telescope.builtin").current_buffer_fuzzy_find()
    end,
    description = "Find string in current buffer",
  },
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
      require("usermod.telescopePickers").prettyGrepPicker({ picker = "live_grep" })
    end,
    description = "Find string in workspace",
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
-- buffer
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
    "<C-p>",
    function()
      require("telescope.builtin").buffers()
    end,
    description = "Pick special buffer",
  },
}