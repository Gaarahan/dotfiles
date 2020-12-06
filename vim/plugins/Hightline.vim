"{ Hightline: }"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

let g:lightline = { 
      \   'colorscheme': 'one',
      \   'active': {
      \     'left': [ [ 'mode', 'paste' ], [ 'gitbranch', 'readonly', 'filename', 'modified' ] ]
      \   },
      \   'tabline': {
      \     'left': [ ['buffers'] ],
      \     'right': [ ['close'] ]
      \   },
      \   'component_expand': {
      \     'buffers': 'lightline#bufferline#buffers',
      \     'gitbranch': 'gitbranch#name'
      \   },
      \   'component_type': {
      \     'buffers': 'tabsel'
      \   }
      \ }
let g:lightline#bufferline#enable_nerdfont = 1

set showtabline=2 " force show tabline

" map leader+<num> to switch buffer
nmap <Leader>1 <Plug>lightline#bufferline#go(1)
nmap <Leader>2 <Plug>lightline#bufferline#go(2)
nmap <Leader>3 <Plug>lightline#bufferline#go(3)
nmap <Leader>4 <Plug>lightline#bufferline#go(4)
nmap <Leader>5 <Plug>lightline#bufferline#go(5)
nmap <Leader>6 <Plug>lightline#bufferline#go(6)
nmap <Leader>7 <Plug>lightline#bufferline#go(7)
nmap <Leader>8 <Plug>lightline#bufferline#go(8)
nmap <Leader>9 <Plug>lightline#bufferline#go(9)
nmap <Leader>0 <Plug>lightline#bufferline#go(10)


