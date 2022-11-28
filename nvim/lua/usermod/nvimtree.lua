local utils = require('usermod.utils')
local map_cmd = utils.map_cmd

map_cmd('n|<F3>', 'NvimTreeToggle', nil)
map_cmd('n|<F4>', 'NvimTreeFindFile', nil)

-- disable netrw at the very start of your init.lua (strongly advised)
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- use g? to show help page
require("nvim-tree").setup({
    sort_by = "case_sensitive",
    view = {
        adaptive_size = true,
        mappings = {
            list = {
                { key = '<C-[>', action = 'dir_up' },
                { key = '-', action = '' }
            },
        },
    },
    renderer = {
        group_empty = true,
    },
    filters = {
        dotfiles = true,
    },
})
