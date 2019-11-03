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

function copyLocalBin() {
    printGreenLine "Coping local bin files..."
    cp -R ./bin/* ~/.local/bin
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
    if [ $PROCEED == 'y' ]; then
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

function installPhpAndComposer() {
    DEFAULT="n"
    read -p 'Install php and composer globally? [y/N]' PROCEED
    # adopt the default, if 'enter' given
    PROCEED="${PROCEED:-${DEFAULT}}"
    # change to lower case to simplify following if
    PROCEED="${PROCEED,,}"
    if [ $PROCEED == 'y' ]; then
        printGreenLine 'Installing php and composer globally...'
        sudo apt-get install php
        curl -sS https://getcomposer.org/installer | sudo php -- --install-dir=/usr/local/bin --filename=composer
    else
        printRedLine 'Skip install php and composer globally'
    fi
}

function installNeovim() {
    DEFAULT="n"
    read -p 'Install neovim? [Y/n]' PROCEED
    # adopt the default, if 'enter' given
    PROCEED="${PROCEED:-${DEFAULT}}"
    # change to lower case to simplify following if
    PROCEED="${PROCEED,,}"
    if [ $PROCEED == 'y' ]; then
        sudo apt-get install nodejs npm
        sudo apt-get install universal-ctags
        printGreenLine "Installing neovim..."
        sudo add-apt-repository ppa:neovim-ppa/stable
        sudo apt-get update
        sudo apt-get install neovim
        vim configuration
        cp -R ./.vim ~/.vim

        printGreenLine "Installing vim plug";
        curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
            https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
        cp config/init.vim ~/.config/nvim
    else
        printRedLine 'Skip install neovim'
    fi
}

function installMycli() {
    DEFAULT="n"
    read -p 'Install mycli? [y/N]' PROCEED
    # adopt the default, if 'enter' given
    PROCEED="${PROCEED:-${DEFAULT}}"
    # change to lower case to simplify following if
    PROCEED="${PROCEED,,}"
    if [ $PROCEED == 'y' ]; then
        printGreenLine "Installing mycli..."
        sudo apt-get install python3-pip 
        pip3 install mycli
    else
        printRedLine 'Skip install mycli'
    fi
}

function installDocker() {
    DEFAULT="n"
    read -p 'Install Docker? [y/N]' PROCEED
    # adopt the default, if 'enter' given
    PROCEED="${PROCEED:-${DEFAULT}}"
    # change to lower case to simplify following if
    PROCEED="${PROCEED,,}"
    if [ $PROCEED == 'y' ]; then
        printGreenLine "Installing Docker..."
        sudo apt-get update
        sudo apt-get install \
            apt-transport-https \
            ca-certificates \
            curl \
            gnupg-agent \
            software-properties-common
        curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
        sudo apt-key fingerprint 0EBFCD88
        sudo add-apt-repository \
            "deb [arch=amd64] https://download.docker.com/linux/ubuntu disco stable"
            #"deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
        sudo apt-get update
        sudo apt-get install docker-ce docker-ce-cli containerd.io
        sudo curl -L "https://github.com/docker/compose/releases/download/1.24.1/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
    else
        printRedLine 'Skip install Docker'
    fi
}

copyLocalBin
installOhMyZsh
installAutoSuggestions
installHstr
installPhpAndComposer
installNeovim
installMycli
installDocker
