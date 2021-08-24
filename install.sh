#!/bin/bash

RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color
SCRIPTPATH="$( cd -- "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )" || exit 1

printRedLine() {
    printf "${RED}$1${NC}\n"
}

printGreenLine() {
    printf "${GREEN}$1${NC}\n"
}

installOhMyZsh() {
    printGreenLine "Installing oh-my-zsh"
    sudo apt-get install -y zsh curl wget
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)" "" --unattended
    if [ ! -f ~/.zshrc_original ]; then
        mv ~/.zshrc ~/.zshrc_original
    fi
    chsh -s /usr/bin/zsh
}

installOhMyZshPlugins() {
    printGreenLine "Installing oh-my-zsh-plugins..."
    PLUGPATH=${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
    [ ! -d "$PLUGPATH" ] && git clone https://github.com/zsh-users/zsh-autosuggestions "$PLUGPATH"
    PLUGPATH=${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
    [ ! -d "$PLUGPATH" ] && git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$PLUGPATH"
    return 0
}

installFzf() {
    printGreenLine "Installing fzf, a fuzzy finder...."
    git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
    ~/.fzf/install
}

installAlacritty() {
    printGreenLine "Installing alacritty..."
    sudo apt-get install -y fonts-hack-ttf
    sudo add-apt-repository -y ppa:mmstick76/alacritty
    sudo apt-get install -y alacritty
}

installTmux() {
    printGreenLine "Installing tmux..."
    sudo apt install -y tmux
}

installMycli() {
    printGreenLine "Installing mycli..."
    sudo apt-get install -y python3-pip
    pip3 install mycli
}

installPhpAndComposer() {
    printGreenLine 'Installing php and composer globally...'
    sudo apt-get install -y php php-xml php-curl php-zip php-mbstring phpmd php-codesniffer
    curl -sS https://getcomposer.org/installer | sudo php -- --install-dir=/usr/local/bin --filename=composer
}

installNode() {
    curl -fsSL https://deb.nodesource.com/setup_current.x | sudo -E bash -
    sudo apt-get install -y nodejs
}

installNeovim() {
    sudo apt-get install -y universal-ctags
    printGreenLine "Installing neovim..."
    sudo add-apt-repository -y ppa:neovim-ppa/stable
    sudo apt-get update
    sudo apt-get install -y neovim

    printGreenLine "Installing vim plug";
    curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
        https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
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
    sudo add-apt-repository -y \
        "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"

    sudo apt-get update
    sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-compose
    sudo groupadd docker
    sudo usermod -aG docker $USER
}

installKubectl() {
    printGreenLine "Installing kubectl..."
    sudo apt-get update &&
    sudo apt-get install -y apt-transport-https ca-certificates curl &&
    sudo curl -fsSLo /usr/share/keyrings/kubernetes-archive-keyring.gpg https://packages.cloud.google.com/apt/doc/apt-key.gpg
    echo "deb [signed-by=/usr/share/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" \
        | sudo tee /etc/apt/sources.list.d/kubernetes.list

    sudo apt-get update
    sudo apt-get install -y kubectl
}

installHelm() {
    # Helm3
    #curl https://baltocdn.com/helm/signing.asc | sudo apt-key add -
    #sudo apt-get install apt-transport-https --yes
    #echo "deb https://baltocdn.com/helm/stable/debian/ all main" | sudo tee /etc/apt/sources.list.d/helm-stable-debian.list
    #sudo apt-get update
    #sudo apt-get install -y helm

    # Helm2
    curl -LO https://git.io/get_helm.sh
    ./get_helm.sh --version v2.16.1
}

installAwsCli() {
    sudo apt-get install -y aws-cli
    printGreenLine "Update .aws/config and .aws/credentials files..."
}

stowDirs() {
    sudo apt-get install -y stow &&
    cd "$SCRIPTPATH" &&
    stow conf
}

installOhMyZsh
installOhMyZshPlugins
installFzf
installAlacritty
installTmux
installMycli
installPhpAndComposer
installNode
installNeovim
installAwsCli
installDocker
installKubectl
installHelm
stowDirs
exit 0
