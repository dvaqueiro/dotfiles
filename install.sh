#!/bin/bash

# --- CONFIGURACIÓN Y COLORES ---
set -e
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m'
SCRIPTPATH="$(cd -- "$(dirname "$0")" >/dev/null 2>&1 && pwd -P)"
STATE_DIR="$HOME/.dotfiles_state"
mkdir -p "$STATE_DIR"

# --- FUNCIONES DE UTILIDAD ---
printGreenLine() { printf "${GREEN}$1${NC}\n"; }
printRedLine() { printf "${RED}$1${NC}\n"; }

# El "corazón" de la idempotencia
run_step() {
    local step_name=$1
    local step_func=$2
    if [ -f "$STATE_DIR/$step_name" ]; then
        printGreenLine ">> [SKIP] Paso '$step_name' ya completado."
    else
        printGreenLine ">> [EXEC] Ejecutando: $step_name..."
        if $step_func; then
            touch "$STATE_DIR/$step_name"
            printGreenLine ">> [OK] Paso '$step_name' finalizado."
        else
            printRedLine "!! [ERROR] Fallo en: $step_name"
            exit 1
        fi
    fi
}

# --- FUNCIONES DE INSTALACIÓN ---
installBasics() {
    sudo apt-get update
    sudo apt-get install -y zsh curl wget git stow unzip build-essential software-properties-common ripgrep fonts-powerline fonts-hack-ttf
}

installOhMyZsh() {
    if [ ! -d "$HOME/.oh-my-zsh" ]; then
        sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
    fi
    # Intentar cambiar shell sin bloquear por contraseña si es posible
    sudo chsh -s /usr/bin/zsh "$USER" || printRedLine "Manual step: run 'chsh -s /usr/bin/zsh'"
}

installOhMyZshPlugins() {
    local PLUG_DIR=${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins
    [ ! -d "$PLUG_DIR/zsh-autosuggestions" ] && git clone https://github.com/zsh-users/zsh-autosuggestions "$PLUG_DIR/zsh-autosuggestions"
    [ ! -d "$PLUG_DIR/zsh-syntax-highlighting" ] && git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$PLUG_DIR/zsh-syntax-highlighting"
    return 0
}

installTmux() {
    sudo apt-get install -y tmux
    # Nuevo del .md: Tmux Plugin Manager
    if [ ! -d "$HOME/.tmux/plugins/tpm" ]; then
        printGreenLine "Instalando TPM (Tmux Plugin Manager)..."
        git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
    fi
}

installNode() {
    printGreenLine "Instalando Node.js v20..."
    curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -
    sudo apt-get install -y nodejs
    sudo npm install -g tldr
}

installNeovim() {
    printGreenLine "Instalando Neovim (Rama de desarrollo para compatibilidad total)..."
    sudo add-apt-repository -y ppa:neovim-ppa/unstable
    sudo apt-get update
    sudo apt-get install -y neovim python3-pip
    pip3 install --user --upgrade pynvim --break-system-packages || true

    curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
}

installFzf() {
    [ -d "$HOME/.fzf" ] && rm -rf "$HOME/.fzf"
    git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
    ~/.fzf/install --all
}

installTools() {
    # Alacritty, Tmux
    sudo apt-get install -y alacritty tmux fonts-hack-ttf
    sudo apt-get install -y python3-pip
    pip3 install mycli --break-system-packages || printRedLine "Fallo mycli, continuando..."
}

installPhpStack() {
    printGreenLine "Instalando PHP y Composer..."
    sudo apt-get install -y php php-xml php-curl php-zip php-mbstring phpmd php-codesniffer

    curl -sS https://getcomposer.org/installer | sudo php -- --install-dir=/usr/local/bin --filename=composer

    printGreenLine "Instalando binario de Phpactor..."
    curl -Lo /tmp/phpactor.phar https://github.com/phpactor/phpactor/releases/latest/download/phpactor.phar
    sudo chmod +x /tmp/phpactor.phar
    sudo mv /tmp/phpactor.phar /usr/local/bin/phpactor
}

installDocker() {
    sudo install -m 0755 -d /etc/apt/keyrings
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list >/dev/null
    sudo apt-get update
    sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin
    sudo usermod -aG docker "$USER"
}

installK8s() {
    if ! command -v kubectl &>/dev/null; then
        sudo curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.31/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg
        echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.31/deb/ /' | sudo tee /etc/apt/sources.list.d/kubernetes.list
        sudo apt-get update && sudo apt-get install -y kubectl
    fi

    printGreenLine "Instalando Helm 3 vía script oficial..."
    curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3
    chmod 700 get_helm.sh
    ./get_helm.sh
    rm get_helm.sh
}

installAws() {
    curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "/tmp/awscliv2.zip"
    unzip -q /tmp/awscliv2.zip -d /tmp
    sudo /tmp/aws/install --update
}

stowDirs() {
    cd "$SCRIPTPATH"
    mkdir -p ~/.config/alacritty ~/.config/nvim ~/.config/phpactor

    # Forzamos borrado de archivos default que bloquean a Stow
    [ -f ~/.zshrc ] && [ ! -L ~/.zshrc ] && mv ~/.zshrc ~/.zshrc.bak

    stow -R zsh
    stow -R tmux
    stow -R nvim
    stow -R alacritty
    stow -R phpactor
    stow -R vim
}

# --- EJECUCIÓN DEL SCRIPT ---
run_step "Basics" installBasics
run_step "OhMyZsh" installOhMyZsh
run_step "ZshPlugins" installOhMyZshPlugins
run_step "Fzf" installFzf
run_step "Tools" installTools
run_step "PhpStack" installPhpStack
run_step "Node" installNode
run_step "Neovim" installNeovim
run_step "Docker" installDocker
run_step "Kubernetes" installK8s
run_step "AwsCli" installAws
run_step "StowLinks" stowDirs

printGreenLine "\n¡SISTEMA LISTO!"
printRedLine "Reinicia la sesión para aplicar cambios."
