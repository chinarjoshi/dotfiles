export HISTFILE=~/.histfile
setopt appendhistory
setopt INC_APPEND_HISTORY  
setopt SHARE_HISTORY
setopt autocd # cd with path name
setopt extended_glob # extended globbing
unsetopt extended_history
unsetopt beep # Inhibit beeping
HISTSIZE=3000
SAVEHIST=3000

autoload -Uz compinit && compinit
zstyle ':completion:*' matcher-list '' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'

typeset -g POWERLEVEL9K_INSTANT_PROMPT=quiet

ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets)
typeset -A ZSH_HIGHLIGHT_STYLES
ZSH_HIGHLIGHT_STYLES[unknown-token]=fg=white
