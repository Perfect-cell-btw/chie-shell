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
compinit

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

# Chie Shell startup
if [[ -o interactive ]]; then
    fastfetch
fi
