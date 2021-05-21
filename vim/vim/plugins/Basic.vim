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
"set fdm=indent                    " set default fold model as indent
set clipboard=unnamed,unnamedplus " use system clipboard
set cursorline
syntax enable                     " use syntax highlighting

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
