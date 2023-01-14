local utils = require('usermod.utils')
local map = utils.map
local map_cmd = utils.map_cmd

require('gitsigns').setup {
    -- { Line_blame : }"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
    current_line_blame = true, -- Toggle with `:Gitsigns toggle_current_line_blame`
    current_line_blame_opts = {
        virt_text = true,
        virt_text_pos = 'eol', -- 'eol' | 'overlay' | 'right_align'
        delay = 1000,
        ignore_whitespace = false,
    },
    current_line_blame_formatter = '<author>, <author_time:%Y-%m-%d> - <summary>',

    on_attach = function(bufnr)
        local gs = package.loaded.gitsigns

        -- { KeyMap : }"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
        -- Navigation
        map('n|]c', 'v:lua.next_hunk()', { expr = true })
        map('n|[c', 'v:lua.prev_hunk()', { expr = true })

        -- Actions
        map_cmd('n|<leader>hS', 'Gitsigns stage_buffer')
        map_cmd('n|<leader>hu', 'Gitsigns undo_stage_hunk')
        map_cmd('n|<leader>hR', 'Gitsigns reset_buffer')
        map_cmd('n|<leader>hp', 'Gitsigns preview_hunk')
        map_cmd('n|<leader>hb', 'Gitsigns blame_line{full=true}')
        map_cmd('n|<leader>hd', "Gitsigns diffthis")
        map_cmd('n|<leader>hD', 'Gitsigns diffthis("~")')
        map_cmd('n|<leader>td', "Gitsigns toggle_deleted")

        -- { Functions : }"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

        function next_hunk()
            if (vim.wo.diff) then
                return ']c'
            end
            vim.schedule(function()
                gs.next_hunk()
            end)
            return '<Ignore>'
        end

        function prev_hunk()
            if (vim.wo.diff) then
                return '[c'
            end
            vim.schedule(function()
                gs.prev_hunk()
            end)
            return '<Ignore>'
        end

    end
}
