local M = {}

-- map helpers
function M.map(mode_and_lhs, rhs, opts)
  local options = {
    noremap = true,
    silent = true,
    expr = false,
    nowait = true,
  }
  if opts then
    options = vim.tbl_extend("force", options, opts)
  end

  local mode, lhs = mode_and_lhs:match "([^|]*)|?(.*)"
  vim.api.nvim_set_keymap(mode, lhs, rhs, options)
end

function M.map_cmd(mode_and_lhs, rhs, opts)
  M.map(mode_and_lhs, string.format("<cmd>%s<CR>", rhs), opts)
end

function M.escape_special_key(cmd)
  return vim.api.nvim_replace_termcodes(cmd, true, false, true)
end

-- map helpers end

-- set option helpers
function M.set_option(options)
  for k, v in pairs(options) do
    vim.opt[k] = v
  end
end
--

return M
