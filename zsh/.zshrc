# Initialize theme
source ~/.cache/p10k-instant-prompt-c.zsh
source $ZDOTDIR/plugins/theme/powerlevel10k.zsh-theme
typeset -g POWERLEVEL9K_INSTANT_PROMPT=quiet

# Settings
export HISTFILE=~/.histfile
setopt appendhistory
setopt INC_APPEND_HISTORY  
setopt SHARE_HISTORY
setopt autocd # cd with path name
setopt extended_glob # extended globbing
unsetopt extended_history
unsetopt beep # Inhibit beeping
autoload -Uz compinit && compinit
zstyle ':completion:*' matcher-list '' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'

# Make unknown command highlight white, not red
ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets)
typeset -A ZSH_HIGHLIGHT_STYLES
ZSH_HIGHLIGHT_STYLES[unknown-token]=fg=white

# Load plugins
for file in $ZDOTDIR/plugins/*; do
    [[ $file == *.zsh ]] && . $file
done

# . ~/.englizsh

# Load sensitive data
[[ -f $HOME/passwd.sh ]] && source $HOME/passwd.sh

# Load aliases
# . $(ACRONYM_GLOBAL_DIR=~/dotfiles acronym -g)
. ~/dotfiles/.aliases.sh

# Load theme configuration (Goes last)
source $ZDOTDIR/plugins/theme/.p10k.zsh

export ACRONYM_GLOBAL_DIR=~/dotfiles
