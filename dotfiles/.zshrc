# =========================================================
# Chie Shell - Zsh
# =========================================================

autoload -Uz colors
colors

setopt PROMPT_SUBST
setopt AUTO_CD
setopt HIST_IGNORE_DUPS
setopt SHARE_HISTORY

HISTFILE="$HOME/.zsh_history"
HISTSIZE=10000
SAVEHIST=10000

autoload -Uz compinit
compinit -C

CHIE_GREEN='%F{148}'
CHIE_YELLOW='%F{220}'
CHIE_MUTED='%F{108}'
CHIE_WHITE='%F{255}'
RESET='%f'

PROMPT='
${CHIE_GREEN}╭─${CHIE_YELLOW}%n${CHIE_MUTED}@${CHIE_GREEN}%m ${CHIE_WHITE}%~${RESET}
${CHIE_GREEN}╰─${CHIE_YELLOW}❯${RESET} '

RPROMPT='${CHIE_MUTED}%*${RESET}'

bindkey '^[[A' history-beginning-search-backward
bindkey '^[[B' history-beginning-search-forward

alias ls='ls --color=auto'
alias ll='ls -lah'
alias la='ls -A'
alias grep='grep --color=auto'
alias cls='clear'
alias c='clear'

alias chie-reload='hyprctl reload'
alias chie-errors='hyprctl configerrors'
alias chie-noti='swaync-client -t'
alias chie-wall='~/.config/hypr/scripts/wallpaper-picker.sh'

echo -e '\e[38;5;220m☻  CHIE SHELL\e[0m  \e[38;5;108m@HOSTNAME@ // @USERNAME@\e[0m'

if [ -f /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh ]; then
    source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
fi

if [ -f /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]; then
    source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
fi

# Chie Shell startup: show Fastfetch once per Hyprland session.
if [[ -o interactive ]]; then
    _chie_runtime="${XDG_RUNTIME_DIR:-$HOME/.cache}"
    _chie_session="${HYPRLAND_INSTANCE_SIGNATURE:-default}"
    _chie_fastfetch_marker="$_chie_runtime/chie-fastfetch-$_chie_session"

    if [[ ! -e "$_chie_fastfetch_marker" ]]; then
        : >| "$_chie_fastfetch_marker" 2>/dev/null
        fastfetch
    fi

    unset _chie_runtime _chie_session _chie_fastfetch_marker
fi
