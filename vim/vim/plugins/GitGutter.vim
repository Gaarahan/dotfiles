set scl=auto

let g:gitgutter_set_sign_backgrounds = 1 " Self define diff color
let g:gitgutter_highlight_linenrs = 1

highlight GitGutterAdd    ctermbg=Green
highlight GitGutterChange ctermbg=Blue
highlight GitGutterDelete ctermbg=Red

let g:gitgutter_sign_added = '+'
let g:gitgutter_sign_modified = '~'
let g:gitgutter_sign_removed = '-'
" let g:gitgutter_sign_removed_first_line = '^^'
" let g:gitgutter_sign_removed_above_and_below = '{'
" let g:gitgutter_sign_modified_removed = 'ww'

