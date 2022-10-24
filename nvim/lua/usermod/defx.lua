local utils = require('usermod.utils')
local map = utils.map
local lua_fn = utils.lua_fn
local map_cmd = utils.map_cmd

map_cmd('n|<F3>', 'Defx', nil)
map_cmd('n|<F4>', 'Defx -resume `expand(\'%:p:h\')` -search=`expand(\'%:p\')`', nil)

vim.fn['defx#custom#option']('_', {
    winwidth = 40,
    split = 'vertical',
    direction = 'topleft',
    show_ignored_files = true,
    buffer_name = '',
    toggle = true,
    resume = true,
    columns = 'indent:icons:filename:type',
    ignored_files = '.*,node_modules',
})

function defxAction(actName)
    return vim.fn['defx#do_action'](actName)
end

defxAction('open_tree')

-- register keymap
local function registerKeyMap()
    map('n|<CR>', lua_fn(function()
        print('got')
        if (vim.fn['defx#is_directory']() == true) then
            defxAction('open_directory')
        else
            defxAction('drop')
        end
    end
    ), { buffer = true })
end

local function configDefxkeyMap()
    if (vim.bo.filetype == 'defx') then
        registerKeyMap()
    end
end

vim.api.nvim_create_autocmd("FileType", {
    pattern = "*",
    callback = configDefxkeyMap
})



--[[
function! s:defx_my_settings() abort
" Define mappings
nnoremap <silent><buffer><expr> <CR>
\ defx#is_directory() ?
\ defx#do_action('open_directory'):defx#do_action('drop')
nnoremap <silent><buffer><expr> y
\ defx#do_action('copy')
nnoremap <silent><buffer><expr> m
\ defx#do_action('move')
nnoremap <silent><buffer><expr> p
\ defx#do_action('paste')
nnoremap <silent><buffer><expr> l
\ defx#is_directory() ?
    \ defx#do_action('open_tree', 'toggle'): ""
    nnoremap <silent><buffer><expr> c
    \ defx#do_action('new_file')
    nnoremap <silent><buffer><expr> C
    \ defx#do_action('new_directory')
    nnoremap <silent><buffer><expr> S
    \ defx#do_action('toggle_sort', 'time')
    nnoremap <silent><buffer><expr> d
    \ defx#do_action('remove')
    nnoremap <silent><buffer><expr> r
    \ defx#do_action('rename')
    nnoremap <silent><buffer><expr> !
    \ defx#do_action('execute_command')
    nnoremap <silent><buffer><expr> x
    \ defx#do_action('execute_system')
    nnoremap <silent><buffer><expr> yy
    \ defx#do_action('yank_path')
    nnoremap <silent><buffer><expr> .
    \ defx#do_action('toggle_ignored_files')
    nnoremap <silent><buffer><expr>;
    \ defx#do_action('repeat')
    nnoremap <silent><buffer><expr> h
    \ defx#do_action('cd', ['..'])
    nnoremap <silent><buffer><expr> ~
    \ defx#do_action('cd')
    nnoremap <silent><buffer><expr> q
    \ defx#do_action('quit')
    nnoremap <silent><buffer><expr> <Space>
    \ defx#do_action('toggle_select') . 'j'
    nnoremap <silent><buffer><expr> *
    \ defx#do_action('toggle_select_all')
    nnoremap <silent><buffer><expr> j
    \ line('.') == line('$') ? 'gg':'j'
    nnoremap <silent><buffer><expr> k
    \ line('.') == 1 ? 'G':'k'
    nnoremap <silent><buffer><expr> <C-l>
    \ defx#do_action('redraw')
    nnoremap <silent><buffer><expr> <C-g>
    \ defx#do_action('print')
    nnoremap <silent><buffer><expr> cd
    \ defx#do_action('change_vim_cwd')
    endfunction
--]]
