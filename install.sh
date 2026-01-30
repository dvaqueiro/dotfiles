#!/bin/bash

set -e # El script se detiene si algo falla

RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color
SCRIPTPATH="$(
    cd -- "$(dirname "$0")" >/dev/null 2>&1
    pwd -P
)" || exit 1

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
    if [ ! -d "$HOME/.fzf" ]; then
        printGreenLine "Installing fzf..."
        git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
        ~/.fzf/install --all
    fi
}

installAlacritty() {
    printGreenLine "Installing alacritty from official repos..."
    sudo apt-get install -y alacritty fonts-hack-ttf
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

installPhpactor() {
    printGreenLine "Instalando Phpactor..."
    # Se instala vía composer globalmente o en una ruta específica
    composer global require phpactor/phpactor --dev
}

installNode() {
    curl -fsSL https://deb.nodesource.com/setup_current.x | sudo -E bash -
    sudo apt-get install -y nodejs
}

installVim() {
    printGreenLine "Instalando Vim..."
    sudo apt-get install -y vim
}

installNeovim() {
    sudo apt-get install -y universal-ctags
    printGreenLine "Installing neovim..."
    sudo add-apt-repository -y ppa:neovim-ppa/stable
    sudo apt-get update
    sudo apt-get install -y neovim

    printGreenLine "Installing vim plug"
    curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
        https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
}

installDocker() {
    printGreenLine "Installing Docker..."
    sudo apt-get update &&
        sudo apt-get install -y \
            ca-certificates \
            curl \
            gnupg \
            lsb-release &&
        curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg &&
        echo \
            "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
      $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list >/dev/null &&
        sudo apt-get update &&
        sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin docker-buildx-plugin &&
        sudo usermod -aG docker $USER
}

installKubectl() {
    printGreenLine "Installing kubectl..."
    sudo apt-get update &&
        sudo apt-get install -y apt-transport-https ca-certificates curl &&
        sudo curl -fsSLo /usr/share/keyrings/kubernetes-archive-keyring.gpg https://packages.cloud.google.com/apt/doc/apt-key.gpg
    echo "deb [signed-by=/usr/share/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" |
        sudo tee /etc/apt/sources.list.d/kubernetes.list

    sudo apt-get update
    sudo apt-get install -y kubectl
}

installHelm() {
    printGreenLine "Installing Helm 3..."
    curl https://baltocdn.com/helm/signing.asc | gpg --dearmor | sudo tee /usr/share/keyrings/helm.gpg >/dev/null
    sudo apt-get install apt-transport-https --yes
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/helm.gpg] https://baltocdn.com/helm/stable/debian/ all main" | sudo tee /etc/apt/sources.list.d/helm-stable-debian.list
    sudo apt-get update
    sudo apt-get install -y helm
}

installAwsCli() {
    curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "/var/tmp/awscliv2.zip"
    unzip /var/tmp/awscliv2.zip
    sudo /var/tmp/aws/install
    aws --version
    printGreenLine "Update .aws/config and .aws/credentials files..."
}

installVarious() {
    sudo apt-get install -y tldr
    printGreenLine "Installl various terminal apps"
}

stowDirs() {
    printGreenLine "Enlazando configuraciones con GNU Stow..."
    cd "$SCRIPTPATH"

    mkdir -p ~/.config/alacritty
    mkdir -p ~/.config/nvim

    stow -R zsh
    stow -R tmux
    stow -R nvim
    stow -R alacritty
    stow -R phpactor
    stow -R vim

    printGreenLine "¡Configuraciones enlazadas!"
}

checkSecrets() {
    printRedLine "RECUERDA: Falta configurar manualmente:"
    echo "1. Llaves SSH en ~/.ssh/"
    echo "2. Credenciales AWS en ~/.aws/credentials"
    echo "3. Configuración de Kubernetes en ~/.kube/config"
}

installOhMyZsh
installOhMyZshPlugins
installFzf
installAlacritty
installTmux
installMycli
installPhpAndComposer
installPhpactor
installNode
installVim
installNeovim
installAwsCli
installDocker
installKubectl
installHelm
installVarious
stowDirs
checkSecrets
