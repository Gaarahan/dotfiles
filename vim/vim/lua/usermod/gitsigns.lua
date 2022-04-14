local utils = require('usermod.utils')
local map = utils.map
local map_cmd = utils.map_cmd


map_cmd('n|<leader>lg', 'LazyGit')


require('gitsigns').setup{
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
    map('n|]c', 'v:lua.next_hunk()', {expr=true})
    map('n|[c', 'v:lua.prev_hunk()', {expr=true})

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
      vim.schedule(function() gs.next_hunk() end)
      return '<Ignore>'
    end

    function prev_hunk() 
      if (vim.wo.diff) then
        return '[c'
      end
      vim.schedule(function() gs.prev_hunk() end)
      return '<Ignore>'
    end

  end
}

-- require('gitsigns').setup{
--   current_line_blame = true, -- Toggle with `:Gitsigns toggle_current_line_blame`
--   current_line_blame_opts = {
--     virt_text = true,
--     virt_text_pos = 'eol', -- 'eol' | 'overlay' | 'right_align'
--     delay = 1000,
--     ignore_whitespace = false,
--   },
--   current_line_blame_formatter = '<author>, <author_time:%Y-%m-%d> - <summary>',
-- 
--   on_attach = function()
--     local gs = package.loaded.gitsigns
-- 
--     -- Navigation
--     map('n|]c', function()
--       if vim.wo.diff then return ']c' end
--       vim.schedule(function() gs.next_hunk() end)
--       return '<Ignore>'
--     end, {expr=true})
-- 
--     map('n|[c', function()
--       if vim.wo.diff then return '[c' end
--       vim.schedule(function() gs.prev_hunk() end)
--       return '<Ignore>'
--     end, {expr=true})
-- 
--     -- Actions
--     map('n|<leader>hS', gs.stage_buffer)
--     map('n|<leader>hu', gs.undo_stage_hunk)
--     map('n|<leader>hR', gs.reset_buffer)
--     map('n|<leader>hp', gs.preview_hunk)
--     map('n|<leader>hb', function() gs.blame_line{full=true} end)
--     map('n|<leader>tb', gs.toggle_current_line_blame)
--     map('n|<leader>hd', gs.diffthis)
--     map('n|<leader>hD', function() gs.diffthis('~') end)
--     map('n|<leader>td', gs.toggle_deleted)
-- 
--     -- Text object
--     map({'o', 'x'}, 'ih', ':<C-U>Gitsigns select_hunk<CR>')
--   end
-- }
