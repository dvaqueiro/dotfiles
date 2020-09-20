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
    mkdir -p ~/.local/bin && cp -R ./bin/* ~/.local/bin
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
        sudo apt-get install -y zsh curl wget
        sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)" "" --unattended
        if [ ! -f ~/.zshrc_original ]; then
            mv ~/.zshrc ~/.zshrc_original
        fi
        cp ./config/zshrc ~/.zshrc
        sudo apt-get install -y fonts-powerline
	chsh -s /usr/bin/zsh
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

function installFzf() {
    DEFAULT="n"
    read -p 'Install fzf? [y/N]' PROCEED
    # adopt the default, if 'enter' given
    PROCEED="${PROCEED:-${DEFAULT}}"
    # change to lower case to simplify following if
    PROCEED="${PROCEED,,}"
    if [ $PROCEED == 'y' ]; then
        printGreenLine "Install fzf, a history improve...."
        git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
        ~/.fzf/install
    else
        printRedLine "Skip install fzf"
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
        sudo apt-get install -y php php-xml php-curl php-zip php-mbstring
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
        curl -sL https://deb.nodesource.com/setup_14.x | sudo -E bash -
        sudo apt-get install -y nodejs
        sudo apt-get install -y universal-ctags
        printGreenLine "Installing neovim..."
        sudo add-apt-repository ppa:neovim-ppa/stable
        sudo apt-get update
        sudo apt-get install -y neovim
        cp -R ./.vim ~/.vim

        printGreenLine "Installing vim plug";
        curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
            https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
        cp config/init.vim ~/.config/nvim/
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
        sudo apt install -y mycli ripgrep
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
        sudo apt-get install -y \
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
        sudo apt-get install docker-ce docker-ce-cli containerd.io docker-compose
        sudo groupadd docker
        sudo usermod -aG docker $USER
    else
        printRedLine 'Skip install Docker'
    fi
}

function installKubectl() {
    DEFAULT="n"
    read -p 'Install kubectl? [y/N]' PROCEED
    # adopt the default, if 'enter' given
    PROCEED="${PROCEED:-${DEFAULT}}"
    # change to lower case to simplify following if
    PROCEED="${PROCEED,,}"
    if [ $PROCEED == 'y' ]; then
        printGreenLine "Installing kubectl..."
        sudo snap install kubectl --classic &&
        sudo snap install helm --classic
    else
        printRedLine 'Skip install kubectl'
    fi
}

function installTmux() {
    DEFAULT="n"
    read -p 'Install tmux? [y/N]' PROCEED
    # adopt the default, if 'enter' given
    PROCEED="${PROCEED:-${DEFAULT}}"
    # change to lower case to simplify following if
    PROCEED="${PROCEED,,}"
    if [ $PROCEED == 'y' ]; then
        printGreenLine "Installing kubectl..."
        sudo apt install -y tmux
        cp config/.tmux.conf ~/.tmux.conf
    else
        printRedLine 'Skip install kubectl'
    fi
}

function installAlacritty() {
    DEFAULT="n"
    read -p 'Install alacritty? [y/N]' PROCEED
    # adopt the default, if 'enter' given
    PROCEED="${PROCEED:-${DEFAULT}}"
    # change to lower case to simplify following if
    PROCEED="${PROCEED,,}"
    if [ $PROCEED == 'y' ]; then
        printGreenLine "Installing alacritty..."
        sudo apt-get install -y fonts-hack-ttf
        sudo add-apt-repository ppa:mmstick76/alacritty
        sudo apt-get install -y alacritty
        cp ./config/alacritty.yml ./.config/alacritty/alacritty.yml
    else
        printRedLine 'Skip install alacritty'
    fi
}

copyLocalBin
installOhMyZsh
installAutoSuggestions
installFzf
installPhpAndComposer
installNeovim
installMycli
installDocker
installKubectl
installAlacritty
