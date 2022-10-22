local utils = require('usermod.utils')
local set_option = utils.set_option
local map = utils.map
local map_cmd = utils.map_cmd
local escape_special_key = utils.escape_special_key

-- Use tab for trigger completion with characters ahead and navigate.
map('i|<TAB>', 'v:lua.tab()', { expr = true, noremap = false })
map('i|<S-TAB>', 'v:lua.shift_tab()', { expr = true, noremap = false })
-- Make <CR> auto-select the first completion item and notify coc.nvim to format on enter, <cr> could be remapped by other vim plugin
map('i|<CR>', 'v:lua.select_cur_complete()', { expr = true, noremap = false })

-- Use `[g` and `]g` to navigate diagnostics, Use `:CocDiagnostics` to get all diagnostics of current buffer in location list.
map('n|[g','<Plug>(coc-diagnostic-prev)', { noremap = false })
map('n|]g','<Plug>(coc-diagnostic-next)', { noremap = false })

-- GoTo code navigation.
map('n|gd', '<Plug>(coc-definition)', { noremap = false })
map('n|gy', '<Plug>(coc-type-definition)', { noremap = false })
map('n|gi', '<Plug>(coc-implementation)', { noremap = false })
map('n|gr', '<Plug>(coc-references)', { noremap = false })
-- Symbol renaming.
map('n|<leader>rn', '<Plug>(coc-rename)', { noremap = false })
-- Use K to show documentation in preview window.
map('n|K', 'v:lua.show_documentation()', { expr = true, noremap = false })

-- Mappings for CoCList
-- Show all diagnostics.
map_cmd('n|<leader>da', 'CocList diagnostics')
-- Manage extensions.
map_cmd('n|<leader>de', 'CocList extensions')
-- Show commands.
map_cmd('n|<leader>dc', 'CocList commands')
-- Find symbol of current document. TODO: maybe show in left panel
map_cmd('n|<leader>do', 'CocList outline')
-- Search workspace symbols.
map_cmd('n|<leader>ds', 'CocList -I symbols')
-- Do default action for next item.
map_cmd('n|<leader>dj', 'CocNext')
-- Do default action for previous item.
map_cmd('n|<leader>dk', 'CocPrev')
-- Resume latest coc list.
map_cmd('n|<leader>dp', 'CocListResume')
-- Highlight the symbol and its references when holding the cursor.
-- Remap keys for applying codeAction to the current buffer.
map('n|<leader>ac', '<Plug>(coc-codeaction)', { noremap = false })
-- Apply AutoFix to problem on the current line.
map('n|<leader>qf', '<Plug>(coc-fix-current)', { noremap = false })

-- Map function and class text objects, can use command like 'vic' to select inner class
-- NOTE: Requires 'textDocument.documentSymbol' support from the language server.
map('x|if', '<Plug>(coc-funcobj-i)' , { noremap = false })
map('o|if', '<Plug>(coc-funcobj-i)' , { noremap = false })
map('x|af', '<Plug>(coc-funcobj-a)' , { noremap = false })
map('o|af', '<Plug>(coc-funcobj-a)' , { noremap = false })
map('x|ic', '<Plug>(coc-classobj-i)', { noremap = false })
map('o|ic', '<Plug>(coc-classobj-i)', { noremap = false })
map('x|ac', '<Plug>(coc-classobj-a)', { noremap = false })
map('o|ac', '<Plug>(coc-classobj-a)', { noremap = false })

-- { Auto command : }"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

vim.cmd('autocmd CursorHold * silent call CocActionAsync("highlight")')
-- Setup formatexpr specified filetype(s).
-- Update signature help on jump placeholder.
vim.cmd[[
  augroup mygroup
    autocmd!
    autocmd FileType typescript,json setl formatexpr=CocAction("formatSelected")
    autocmd User CocJumpPlaceholder call CocActionAsync("showSignatureHelp")
  augroup end
]]

-- { Functions : }"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""


function show_documentation()
  if (vim.bo.filetype == 'help' or vim.bo.filetype == 'vim') then
    vim.cmd("execute 'h '.expand('<cword>')")
  elseif (vim.fn['coc#rpc#ready']() == 1) then
    vim.fn.CocActionAsync('doHover')
  else 
    vim.cmd("execute '!' . &keywordprg . \" \" . expand('<cword>')")
  end
end

function tab()
  return vim.fn['coc#pum#visible']() == 1
    and vim.fn['coc#pum#next'](1) 
    or (
      check_back_space() 
        and utils.escape_special_key('<Tab>')
        or vim.fn['coc#refresh']()
    )
end

function shift_tab() 
  return vim.fn['coc#pum#visible']() == 1
    and vim.fn['coc#pum#prev'](1) 
    or utils.escape_special_key('<C-h>')
end

function select_cur_complete() 
  return vim.fn['coc#pum#visible']() == 1
    and vim.fn['coc#pum#confirm']() 
    or utils.escape_special_key('<C-g>u<CR><c-r>=coc#on_enter()<CR>')
end
  
function check_back_space()
  local col = vim.fn.col('.') - 1
  return col <= 0 or vim.fn.getline('.'):sub(col, col):match('%s')
end

-- Use the CocI too install language server for coc :
vim.api.nvim_create_user_command(
  'CocI',
  'CocInstall coc-html coc-css coc-tsserver coc-vetur coc-json coc-sh coc-clangd coc-markdownlint coc-prettier',
  { nargs = 0 }
)

-- Add `:Format` command to format current buffer.
vim.api.nvim_create_user_command(
  'Format',
  function () 
    vim.fn.CocAction("format")
  end,
  { nargs = 0 }
)

-- Add `:OR` command for organize imports of the current buffer.
vim.api.nvim_create_user_command(
  'OR',
  function () 
    vim.fn.CocAction("runCommand", "editor.action.organizeImport")
  end,
  { nargs = 0 }
)
