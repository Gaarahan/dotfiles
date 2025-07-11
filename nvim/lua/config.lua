-- { Load module: }"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

local conf_modules = {
  "plugins.plugin", -- init plugin

  -- config ---
  "basic",
  "keymaps.keymap", -- config keymaps
  "appearance",
  "nvim-ufo",
}

for i = 1, #conf_modules do
  local modulePath = "./usermod." .. conf_modules[i]
  require(modulePath)
end
