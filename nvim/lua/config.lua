-- { Load module: }"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

local conf_modules = {
    'basic',
    'keymap',
    'appearance',
    'buffers',
    'coc',
    'gitsigns',
    'defx',
}

for i = 1, #conf_modules do
    local modulePath = './usermod.' .. conf_modules[i]
    require(modulePath)
end

