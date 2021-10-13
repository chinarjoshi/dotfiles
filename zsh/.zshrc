# Load cached prompt to speed up initialization (Goes first)
source $ZDOTDIR/theme/instant-prompt.zsh

setopt autocd # cd with path name
unsetopt beep # Inhibit beeping
source $ZDOTDIR/theme/powerlevel10k.zsh-theme
typeset -g POWERLEVEL9K_INSTANT_PROMPT=quiet
autoload -Uz compinit && compinit
zstyle ':completion:*' matcher-list '' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'

# Convenience directories
rust=$HOME/projects/rust
java=$HOME/projects/java
org=$HOME/org
zsh=$ZDOTDIR
dot=$DOTFILES
down=$HOME/Downloads

for file in $ZDOTDIR/custom/*; do
    source $file
done

for file in $ZDOTDIR/plugins/*; do
    [[ $file == *.zsh ]] && source $file
done

# Load theme configuration (Goes last)
source $ZDOTDIR/theme/.p10k.zsh
