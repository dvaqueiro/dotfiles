#!/bin/bash

RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color

function installOhMyZsh() {
    DEFAULT="n"
    read -p 'Install Oh My Zsh? [y/N]' PROCEED
    # adopt the default, if 'enter' given
    PROCEED="${PROCEED:-${DEFAULT}}"
    # change to lower case to simplify following if
    PROCEED="${PROCEED,,}"
    if [ $PROCEED == 'y' ]
    then
        printf "${GREEN}Installing Oh My Zsh...${NC}\n"
	sudo apt-get install zsh curl wget
	sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)" "" --unattended
	if [ ! -f ~/.zshrc_original ]; then
	    mv ~/.zshrc ~/.zshrc_original
	fi
	cp ./config/zshrc ~/.zshrc
	sudo apt-get install fonts-powerline
    else
        printf "${RED}Skip install Oh My Zsh${NC}\n"
    fi
}

function installComposer() {
    DEFAULT="y"
    read -p 'Install composer globally? [Y/n]' PROCEED
    # adopt the default, if 'enter' given
    PROCEED="${PROCEED:-${DEFAULT}}"
    # change to lower case to simplify following if
    PROCEED="${PROCEED,,}"
    if [ $PROCEED == 'n' ]
    then
        echo 'Skip install composer globally'
    else
        echo 'Installing composer globally...'
        curl -sS https://getcomposer.org/installer | sudo php -- --install-dir=/usr/local/bin --filename=composer
    fi
}

function installNeovim() {
    DEFAULT="y"
    read -p 'Install neovim? [Y/n]' PROCEED
    # adopt the default, if 'enter' given
    PROCEED="${PROCEED:-${DEFAULT}}"
    # change to lower case to simplify following if
    PROCEED="${PROCEED,,}"
    if [ $PROCEED == 'n' ]
    then
        echo 'Skip install neovim'
    else
        echo "Installing neovim...";
        sudo add-apt-repository ppa:neovim-ppa/stable
        sudo apt-get update
        sudo apt-get install neovim
        # vim configuration
        ln -sf ~/dev/dotfiles/.vim ~/.vim

        echo "Installing vim plug";
        curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
            https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    fi
}

function installMycli() {
    DEFAULT="y"
    read -p 'Install mycli? [Y/n]' PROCEED
    # adopt the default, if 'enter' given
    PROCEED="${PROCEED:-${DEFAULT}}"
    # change to lower case to simplify following if
    PROCEED="${PROCEED,,}"
    if [ $PROCEED == 'n' ]
    then
        echo 'Skip install install mycli'
    else
        echo "Installing mycli..."
        pip install mycli
    fi
}

function installHstr() {
    DEFAULT="y"
    read -p 'Install hstr, a history improve? [Y/n]' PROCEED
    # adopt the default, if 'enter' given
    PROCEED="${PROCEED:-${DEFAULT}}"
    # change to lower case to simplify following if
    PROCEED="${PROCEED,,}"
    if [ $PROCEED == 'n' ]
    then
        echo "Skip install hstr"
    else
        echo "Install hstr, a history improve...."
        sudo add-apt-repository ppa:ultradvorka/ppa && sudo apt-get update && sudo apt-get install hstr && hstr --show-configuration >> ~/.zshrc && . ~/.zshrc
    fi
}

function installAutoSuggestions() {
    DEFAULT="y"
    read -p 'Install auto suggestions? [Y/n]' PROCEED
    # adopt the default, if 'enter' given
    PROCEED="${PROCEED:-${DEFAULT}}"
    # change to lower case to simplify following if
    PROCEED="${PROCEED,,}"
    if [ $PROCEED == 'n' ]
    then
        echo "Skip install zsh auto suggestions"
    else
        echo "Install zsh auto suggestions..."
        echo "add plugins=(zsh-autosuggestions) to .zshr"
        git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
    fi
}

installOhMyZsh
#installComposer
#installNeovim
#installMycli
#installHstr
#installAutoSuggestions
