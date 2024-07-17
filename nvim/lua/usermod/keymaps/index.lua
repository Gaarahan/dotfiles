local keymapList = {
  {
    "<leader>fc",
    ":Legendary<CR>",
    description = "Find Command",
  },
  {
    "<leader>sv",
    ":source $MYVIMRC<CR>",
    description = "Source vim configuration",
  },
}
local keymapGroup = {
  require('usermod.keymaps.git_keymaps'),
  require('usermod.keymaps.language_enhanced'),
  require('usermod.keymaps.efficiency_edit_keymaps'),
  require('usermod.keymaps.search_jump_keymaps'),
}

for _, group in ipairs(keymapGroup) do
  for _, keymap in ipairs(group) do
    table.insert(keymapList, keymap)
  end
end

return keymapList
