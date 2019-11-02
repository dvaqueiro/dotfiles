#!/bin/bash

RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color

function printRedLine() {
    printf "${RED}$1${NC}\n"
}

function printGreenLine() {
    printf "${GREEN}$1${NC}\n"
}

function installOhMyZsh() {
    DEFAULT="n"
    read -p 'Install Oh My Zsh? [y/N]' PROCEED
    # adopt the default, if 'enter' given
    PROCEED="${PROCEED:-${DEFAULT}}"
    # change to lower case to simplify following if
    PROCEED="${PROCEED,,}"
    if [ $PROCEED == 'y' ]; then
        printGreenLine "Installing Oh My Zsh..."
	sudo apt-get install zsh curl wget
	sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)" "" --unattended
	if [ ! -f ~/.zshrc_original ]; then
	    mv ~/.zshrc ~/.zshrc_original
	fi
	cp ./config/zshrc ~/.zshrc
	sudo apt-get install fonts-powerline
    else
        printRedLine "Skip install Oh My Zsh"
    fi
}

function installAutoSuggestions() {
    DEFAULT="n"
    read -p 'Install auto suggestions? [y/N]' PROCEED
    # adopt the default, if 'enter' given
    PROCEED="${PROCEED:-${DEFAULT}}"
    # change to lower case to simplify following if
    PROCEED="${PROCEED,,}"
    if [ $PROCEED == 'y' ]; then
	printGreenLine "Install zsh auto suggestions..."
	printGreenLine "add plugins=(zsh-autosuggestions) to .zshr"
        git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
    else
        printRedLine "Skip install zsh auto suggestions"
    fi
}

function installHstr() {
    DEFAULT="n"
    read -p 'Install hstr, a history improve? [y/N]' PROCEED
    # adopt the default, if 'enter' given
    PROCEED="${PROCEED:-${DEFAULT}}"
    # change to lower case to simplify following if
    PROCEED="${PROCEED,,}"
    if [ $PROCEED == 'y' ]
    then
        printGreenLine "Install hstr, a history improve...."
        git clone https://github.com/dvorka/hstr.git
        sudo apt install automake gcc make libncursesw5-dev libreadline-dev
        cd ./hstr
        cd ./build/tarball && ./tarball-automake.sh && cd ../..
        ./configure && make && sudo make install
        cd ..
        rm -Rf ./hstr
    else
        printRedLine "Skip install hstr"
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

installOhMyZsh
installAutoSuggestions
installHstr
#installComposer
#installNeovim
#installMycli
