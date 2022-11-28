local utils = require('usermod.utils')
local map = utils.map
local map_cmd = utils.map_cmd
local lua_fn = utils.lua_fn

-- disable virtual_text
vim.diagnostic.config({
  virtual_text = false
})

map_cmd('n|<leader>ac', 'Lspsaga code_action')
map_cmd('n|<leader>rn', 'Lspsaga rename')

map_cmd('n|<leader>ld', 'Lspsaga show_line_diagnostics')
map_cmd('n|<leader>cd', 'Lspsaga show_cursor_diagnostics')

map_cmd('n|gr', 'Lspsaga lsp_finder')
map_cmd('n|gd', 'Lspsaga peek_definition')

-- go to diagnsotic
map_cmd('n|[e', 'Lspsaga diagnostic_jump_prev', { silent = true })
map_cmd('n|]e', 'Lspsaga diagnostic_jump_next', { silent = true })

map('n|[E', lua_fn(function() 
  require("lspsaga.diagnostic").goto_prev({ severity = vim.diagnostic.severity.ERROR })
end), { silent = true })
map('n|]E', lua_fn(function()
  require("lspsaga.diagnostic").goto_next({ severity = vim.diagnostic.severity.ERROR })
end), { silent = true })

map_cmd('n|<leader>o', 'LSoutlineToggle', { silent = true })
map_cmd('n|K', 'Lspsaga hover_doc', { silent = true })
