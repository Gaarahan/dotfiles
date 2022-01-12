"{ Basic: }"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

nnoremap <SPACE> <Nop>
let mapleader=" "

" edit and source vimrc
"nnoremap <leader>ev :vsp $MYVIMRC<cr>
nnoremap <leader>sv :source $MYVIMRC<cr>

" enable ruler
set ruler
set laststatus=2
set nu
set clipboard=unnamed,unnamedplus " use system clipboard
set cursorline
syntax enable                     " use syntax highlighting
set fdm=syntax
set encoding=utf-8                " configure the encoding
set fileencoding=utf-8
set mouse=a                       " enable mouse

set tabstop=2                     " Insert 2 spaces for a tab
set softtabstop=-1                " Automatically keeps in sync with shiftwidth
set shiftwidth=2                  " Change the number of space characters inserted for indentation
set smarttab                      " Makes tabbing smarter will realize you have 2 vs 4
set expandtab                     " Converts tabs to spaces
set smartindent                   " Makes indenting smart

set smartcase                     " Makes search use smart case
set ignorecase

set updatetime=100                " Change vim update delay to update git change sign when edit
set hidden                        " Can change to other buffer when have unsaved change

autocmd BufEnter *.png, *.jpg, *.gif exec "silent !open ".expand("%") | :bw

vnoremap p "_s<C-r>"<esc>

" save undo trees in files
set undofile
set undodir=~/.vim/undo

" number of undo saved
set undolevels=10000

" ---- For coc.vim

" Always show the signcolumn, otherwise it would shift the text each time
" diagnostics appear/become resolved.
if has("nvim-0.5.0") || has("patch-8.1.1564")
  " Recently vim can merge signcolumn and number column into one
  set signcolumn=number
else
  set signcolumn=yes
endif

" Some servers have issues with backup files, see #649.
set nobackup
set nowritebackup

" Give more space for displaying messages.
" set cmdheight=2

" Don't pass messages to |ins-completion-menu|.
set shortmess+=c

" ---- End from coc.vim
