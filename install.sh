#!/bin/bash

RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color

printRedLine() {
    printf "${RED}$1${NC}\n"
}

printGreenLine() {
    printf "${GREEN}$1${NC}\n"
}

copyLocalBin() {
    printGreenLine "Coping local bin files..."
    mkdir -p ~/.local/bin && cp -R ./bin/* ~/.local/bin
}

installOhMyZsh() {
    sudo apt-get install -y zsh curl wget
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)" "" --unattended
    if [ ! -f ~/.zshrc_original ]; then
        mv ~/.zshrc ~/.zshrc_original
    fi
    cp ./config/zshrc ~/.zshrc
    sudo apt-get install -y fonts-powerline
    chsh -s /usr/bin/zsh
}

installAutoSuggestions() {
    printGreenLine "Install zsh auto suggestions..."
    printGreenLine "add plugins=(zsh-autosuggestions) to .zshr"
    git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
}

installFzf() {
    printGreenLine "Install fzf, a history improve...."
    git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
    ~/.fzf/install
}

installPhpAndComposer() {
    printGreenLine 'Installing php and composer globally...'
    sudo apt-get install -y php php-xml php-curl php-zip php-mbstring phpmd php-codesniffer
    curl -sS https://getcomposer.org/installer | sudo php -- --install-dir=/usr/local/bin --filename=composer
}

installNeovim() {
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
}

installMycli() {
    printGreenLine "Installing mycli..."
    sudo apt install -y mycli ripgrep
}

installDocker() {
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
}

installKubectl() {
    printGreenLine "Installing kubectl..."
    sudo snap install kubectl --classic &&
    sudo snap install helm --classic
}

installTmux() {
    printGreenLine "Installing kubectl..."
    sudo apt install -y tmux
    cp config/.tmux.conf ~/.tmux.conf
}

installAlacritty() {
    printGreenLine "Installing alacritty..."
    sudo apt-get install -y fonts-hack-ttf
    sudo add-apt-repository ppa:mmstick76/alacritty
    sudo apt-get install -y alacritty
    cp ./config/alacritty.yml ./.config/alacritty/alacritty.yml
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
