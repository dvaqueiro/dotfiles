# 🚀 Dotfiles de dvaqueiro

Mi entorno de desarrollo personalizado y automatizado para Ubuntu/Debian. Basado en **Zsh**, **Neovim**, **Tmux** y **GNU Stow**.

## 🛠️ Herramientas principales

- **Shell:** Zsh con Oh My Zsh (+ autosuggestions & highlighting).
- **Editor:** Neovim (configuración Lua con Lazy.nvim) y Vim.
- **Terminal:** Alacritty con Hack Nerd Font.
- **Productividad:** Tmux (TPM), FZF, Ripgrep, tldr.
- **Dev Stack:** Docker, Kubernetes (kubectl & helm 3), AWS CLI, PHP (Composer & Phpactor), Node.js (v20).

## 📂 Estructura del Repositorio

El repositorio utiliza **GNU Stow** para gestionar enlaces simbólicos. Cada carpeta representa un paquete de configuración:

- `zshrc/`: Configuración de la shell (`.zshrc`).
- `nvim/`: Configuración moderna en Lua (`~/.config/nvim`).
- `tmux/`: Multiplexor de terminal y plugins.
- `alacritty/`: Configuración del emulador de terminal.
- `bin/`: Scripts de utilidad personal (no gestionados por Stow, añadidos al PATH).
- `phpactor/`: Plantillas y configuración para desarrollo PHP.
- `vim/`: Configuración clásica de Vim.

## 🚀 Instalación Rápida

Para una instalación limpia en un sistema Ubuntu/Debian, ejecuta:

```bash
git clone [https://github.com/dvaqueiro/dotfiles.git](https://github.com/dvaqueiro/dotfiles.git) ~/.dotfiles
cd ~/.dotfiles
bash install.sh
```

> Nota: El script es idempotente. Puedes ejecutarlo varias veces y solo procesará los pasos pendientes o fallidos. El estado se guarda en ~/.dotfiles_state.

## 🔐 Configuración Manual (Post-Instalación)

Por seguridad, ciertos archivos no se incluyen en este repositorio y deben gestionarse manualmente:

1. SSH: Copia tus llaves a ~/.ssh/.
2. AWS: Configura tus credenciales con aws configure.
3. Kubeconfig: Copia tu archivo de configuración a ~/.kube/config.
4. Zsh Local: Si necesitas variables de entorno privadas, añádelas en ~/.zshrc.local.

Mantenido por [dvaqueiro](https://github.com/dvaqueiro).
