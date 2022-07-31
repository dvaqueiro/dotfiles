" set runtimepath-=~/.config/nvim/after
" set runtimepath^=~/.vim runtimepath+=~/.vim/after
" let &packpath = &runtimepath
" source ~/.vim/vimrc

set guifont=Hack\ 14

let mapleader = "\<space>"

set encoding=UTF-8
set nocompatible

set number
set cursorline
set scrolloff=8
set wrap
set showbreak=↳
set colorcolumn=80

" default tab conf
set expandtab
set tabstop=4
set softtabstop=4
set shiftwidth=4
set autoindent

" search behaivour
set nohlsearch
set incsearch

" history
set noswapfile
set nobackup
set undodir=~/.vim/undodir
set undofile

set listchars=eol:$,tab:>-,trail:~,extends:>,precedes:<,space:·
set updatetime=50

syntax enable
filetype plugin indent on

" netrw file browser
let g:netrw_banner=0
let g:netrw_liststyle=4

" remove trailing whitespace when saving php files
" autocmd BufWritePre *.php :%s/\s\+$//e
autocmd BufWritePre * %s/\s\+$//e

runtime ./keymaps.vim
runtime ./plug.vim
