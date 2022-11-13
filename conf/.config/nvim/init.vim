syntax enable
filetype plugin indent on

runtime ./keymaps.vim
runtime ./plug.vim

lua << EOF
require("dvaqueiro")
EOF
