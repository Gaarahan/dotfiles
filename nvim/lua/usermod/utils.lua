local M = {}
local module_name = 'usermod.utils'
local fn_store = {}

local function register_fn(fn)
    table.insert(fn_store, fn)
    return #fn_store
end

function M.apply_function(id)
    fn_store[id]()
end

function M.apply_expr(id)
    return vim.api.nvim_replace_termcodes(fn_store[id](), true, true, true)
end

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
    if (opts and opts.buffer == true) then
        options.buffer = nil
        vim.api.nvim_buf_set_keymap(0, mode, lhs, rhs, options)
    else
        vim.api.nvim_set_keymap(mode, lhs, rhs, options)
    end
end

function M.map_cmd(mode_and_lhs, rhs, opts)
    M.map(mode_and_lhs, string.format("<cmd>%s<CR>", rhs), opts)
end

-- allow use fn in map rhs
function M.lua_fn(fn)
    return string.format(
            "<cmd>lua require('%s').apply_function(%s)<CR>",
            module_name,
            register_fn(fn)
    )
end

-- allow use expr in map rhs
function M.lua_expr(fn)
    return string.format(
            "v:lua.require'%s'.apply_expr(%s)",
            module_name,
            register_fn(fn)
    )
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
