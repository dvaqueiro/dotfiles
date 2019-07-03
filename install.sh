#!/bin/bash

# vim configuration
ln -sf ~/dev/dotfiles/.vim ~/.vim

echo "Installing vim plug";
curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
