# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/robbyrussell/oh-my-zsh/wiki/Themes
ZSH_THEME="robbyrussell"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in ~/.oh-my-zsh/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in ~/.oh-my-zsh/plugins/*
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(
    git
    zsh-autosuggestions
    zsh-syntax-highlighting
)

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
if [[ -n $SSH_CONNECTION ]]; then
   export EDITOR='vim'
else
   export EDITOR='nvim'
fi

if [[ -f ~/.zsh_secrets ]]; then
    source ~/.zsh_secrets
fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# ssh
# export SSH_KEY_PATH="~/.ssh/rsa_id"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
alias zshconfig="nvim ~/.zshrc"
alias hadolint="docker run --rm -i hadolint/hadolint <"
alias tm="tmux attach || tmux"
alias oc="opencommit"
# alias ohmyzsh="mate ~/.oh-my-zsh"

# alias util='kubectl get nodes --no-headers | awk '\''{print $1}'\'' | xargs -I {} sh -c '\''echo {} ; kubectl describe node {} | grep Allocated -A 5 | grep -ve Event -ve Allocated -ve percent -ve -- ; echo '\'''

# Get CPU request total (we x20 because because each m3.large has 2 vcpus (2000m) )
# alias cpualloc='util | grep % | awk '\''{print $1}'\'' | awk '\''{ sum += $1 } END { if (NR > 0) { print sum/(NR*20), "%\n" } }'\'''

# Get mem request total (we x75 because because each m3.large has 7.5G ram )
# alias memalloc='util | grep % | awk '\''{print $5}'\'' | awk '\''{ sum += $1 } END { if (NR > 0) { print sum/(NR*75), "%\n" } }'\'''

export HISTFILE=~/.zsh_history  # ensure history file visibility
export HISTSIZE=20000

export LESS="-XFR"
export PATH="$HOME/.symfony/bin:$PATH"
export PATH="$HOME/.dotfiles/bin:$PATH"
export PATH="$HOME/.config/composer/vendor/bin:$PATH"
export PATH="$HOME/Documents/dev/phpactor/bin:$PATH"
export PATH="$HOME/.symfony5/bin:$PATH"
export PATH="$HOME/.npm-global/bin:$PATH"

# Asegurar que el PATH sea único (evita duplicados si recargas la shell)
typeset -U path

#export DEVOPS_PATH=/home/dvaqueiro/projects/devops

# --files: List files that would be searched but do not search
# --no-ignore: Do not respect .gitignore, etc...
# --hidden: Search hidden files and folders
# --follow: Follow symlinks
# --glob: Additional conditions for search (in this case ignore everything in the .git/ folder)
export FZF_DEFAULT_COMMAND='rg --files --ignore --hidden --follow --glob "!.git/*"'

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

function gitdiff() {
   git -c color.status=always status --short |
      fzf --height 100% --ansi \
      --preview '(git diff HEAD --color=always -- {-1} | sed 1,4d)' \
      --preview-window right:65% |
      cut -c4- |
      sed 's/.* -> //' |
      tr -d '\n' |
      pbcopy
}

# ------------------------------------------------------------------
# TMUX WORKSPACE AUTOMATION (CON FZF)
# ------------------------------------------------------------------
function workon() {
    local PROJECTS_DIR="$HOME/Documents/dev/boardfy/"
    local DEVOPS_DIR="$HOME/Documents/dev/boardfy/devops/"

    local project_dir
    local project_name

    if [ "$#" -eq 0 ]; then
        # Buscamos carpetas en tu directorio de proyectos (solo 1 nivel de profundidad) y se las pasamos a fzf
        project_dir=$(find "$PROJECTS_DIR" -mindepth 1 -maxdepth 1 -type d 2>/dev/null | fzf --prompt="🚀 Selecciona proyecto: " --height=40% --layout=reverse --border --info=inline)

        # Si el usuario pulsa ESC o Ctrl+C para cancelar fzf
        if [ -z "$project_dir" ]; then
            return 0
        fi

        # Extraemos el nombre de la carpeta como nombre del proyecto
        project_name=$(basename "$project_dir")

    # 2. MODO MANUAL (Con argumentos -> workon <nombre> <ruta>)
    elif [ "$#" -eq 2 ]; then
        project_name=$1
        project_dir=$2
    else
        echo "❌ Uso manual: workon <nombre_proyecto> <ruta>"
        echo "💡 Uso interactivo: Solo escribe 'workon'"
        return 1
    fi

    # Limpiamos el nombre para Tmux (a Tmux no le gustan los puntos en los nombres de sesión)
    project_name=$(echo "$project_name" | tr '.' '_')

    # Navegamos al directorio
    cd "$project_dir" || return 1

    # Comprobamos si la sesión ya existe para no pisarla
    if ! tmux has-session -t "$project_name" 2>/dev/null; then
        echo "🚀 Levantando infraestructura para: $project_name..."
        # Ventana 1: Código (crea la sesión en background)
        tmux new-session -d -s "$project_name" -n "code"
        # Ventana 2: Tests
        tmux new-window -t "$project_name":2 -n "tests"
        tmux split-window -t "$SESSION_NAME:2" -v
        # Ventana 3: BBDD
        tmux new-window -t "$project_name":3 -n "bbdd"
        # Ventana 5: DevOps (Ruta forzada con -c)
        tmux new-window -t "$project_name":4 -n "devops" -c "$DEVOPS_DIR"
        # Ventana 5: Varios
        tmux new-window -t "$project_name":5 -n "ramdom"
        # Volvemos a la pestaña de código para empezar
        tmux select-window -t "$project_name":1
    fi

    # Lógica de conexión inteligente (con atajo para evitar errores visuales)
    if [ -z "$TMUX" ]; then
        tmux attach -t "$project_name"
    else
        tmux switch-client -t "$project_name"
    fi
}

# ------------------------------------------------------------------
# TMUX WORKSPACE TEARDOWN
# ------------------------------------------------------------------
function workoff() {
    local session_name

    # 1. Si le pasas un nombre a mano (ej: workoff backend)
    if [ "$#" -eq 1 ]; then
        session_name=$1
    # 2. Si no le pasas nombre, pero lo ejecutas DENTRO del proyecto
    elif [ -n "$TMUX" ]; then
        session_name=$(tmux display-message -p '#S')
    else
        echo "❌ No estás en Tmux o no has especificado qué proyecto cerrar."
        echo "💡 Uso: workoff <nombre_proyecto> (o ejecuta 'workoff' dentro de la sesión)"
        return 1
    fi

    # Confirmación de seguridad para evitar accidentes
    echo -n "⚠️ ¿Seguro que quieres destruir el workspace '$session_name' y cerrar sus ventanas? (y/n): "
    read -r confirm
    if [[ "$confirm" =~ ^[YySsiI] ]]; then
        echo "💥 Destruyendo sesión '$session_name'..."

        # 🚀 LA MEJORA SRE: Si estamos dentro de Tmux y en la sesión activa,
        # saltamos a la siguiente sesión disponible antes de destruirla.
        if [ -n "$TMUX" ]; then
            local current_session
            current_session=$(tmux display-message -p '#S')
            if [ "$current_session" = "$session_name" ]; then
                tmux switch-client -n 2>/dev/null
            fi
        fi

        # Ahora sí, borramos la sesión de forma segura
        tmux kill-session -t "$session_name"
        echo "✅ Proyecto cerrado limpiamente."
    else
        echo "🛑 Abortado. Tu proyecto sigue vivo."
    fi
}

alias k8lf='k8 lf'

# Load local settings (not versioned)
if [ -f ~/.zshrc.local ]; then
    source ~/.zshrc.local
fi

# ------------------------------------------------------------------
# CONFIGURACIÓN KEYCHAIN (Limpia y Robusta)
# ------------------------------------------------------------------
unset SSH_ASKPASS

if [ -n "$TMUX" ]; then
    # 1. ESTAMOS DENTRO DE TMUX (restaurando paneles):
    # Heredamos la conexión en silencio.
    eval $(keychain --eval --agents ssh)
else
    # 2. ESTAMOS FUERA DE TMUX (Alacritty o Tilix base):
    # Cargamos la llave principal y pedimos la clave de forma segura en la terminal.
    eval $(keychain --eval --agents ssh id_bfy_master)
fi

note() {
    # Directorio donde vivirán tus notas (cámbialo al que prefieras)
    local notes_dir="$HOME/.notes"
    mkdir -p "$notes_dir"

    # Archivo diario (ej: 2026-07-23.md)
    local filename="$notes_dir/notes.md"

    # Si tienes la variable $EDITOR configurada a nvim, la usará. Si no, forzamos nvim.
    local editor=${EDITOR:-nvim}

    if [ -z "$1" ]; then
        # Sin argumentos: abre Neovim en el archivo de hoy
        $editor "$filename"
    else
        # Con argumentos: añade una línea con la hora y tu nota
        echo "- **$(date +%H:%M):** $*" >> "$filename"
        echo "✅ Nota guardada en $filename"
    fi
}

# Comando inteligente para commits con Gemini y selector de modelos
function gcomm() {
# 1. Comprobar si hay cambios cacheados
    if git diff --cached --quiet; then
        echo "❌ No hay archivos en el stage. Usa 'git add' primero."
        return 1
    fi

    # 2. Selector interactivo de modelos
    echo "Elige el modelo de Gemini a usar:"
    local models=("Por defecto del CLI (Recomendado)" "Flash exacto (001)" "Flash exacto (002)" "Cancelar")
    local selected_model=""
    local api_model=""

    select opt in "${models[@]}"; do
        case $REPLY in
            1)
                selected_model="CLI Default"
                api_model="" # Lo dejamos vacío para no forzar el flag -m
                break
                ;;
            2)
                selected_model="Flash-001"
                api_model="gemini-1.5-flash-001"
                break
                ;;
            3)
                selected_model="Flash-002"
                api_model="gemini-1.5-flash-002"
                break
                ;;
            4)
                echo "Operación cancelada."
                return 0
                ;;
            *)
                echo "Opción invalida."
                ;;
        esac
    done

    echo "🤖 Analizando diff con Gemini ($selected_model)..."

    # 3. Enviar el diff al modelo seleccionado
    git diff --cached | gemini -m "$api_model" -p "Actúa como un desarrollador Senior. Escribe un mensaje de commit usando la convención de Conventional Commits (ej. feat:, fix:, test:, chore:).
    El mensaje debe estar en INGLÉS.
    Formato requerido:
    1. Una primera línea corta con el tipo y la descripción.
    2. Una línea en blanco.
    3. Un resumen para dar contexto de los cambios
    4. Una línea en blanco.
    5. Una explicación detallada en viñetas sobre el 'qué' y el 'por qué' de los cambios.

    Devuelve ÚNICAMENTE el texto crudo del commit. Nada de saludos, ni bloques de código markdown (\`\`\`)." > .git/COMMIT_EDITMSG

    # 4. Comprobar si la llamada falló o el archivo está vacío
    if [[ ! -s .git/COMMIT_EDITMSG ]]; then
        echo "❌ Error: La API no devolvió contenido o falló (revisa el log de arriba). Abortando."
        return 1
    fi

    # 5. Lanzar Git
    git commit -e -F .git/COMMIT_EDITMSG
}
