# Load cached prompt to speed up initialization (Goes first)
source $ZDOTDIR/theme/instant-prompt.zsh

setopt autocd # cd with path name
unsetopt beep # Inhibit beeping
source $ZDOTDIR/theme/powerlevel10k.zsh-theme

# Append binary user directories to PATH
rust=$HOME/projects/rust
java=$HOME/projects/java
zsh=$ZDOTDIR

for file in $ZDOTDIR/custom/*; do
    source $file
done

for file in $ZDOTDIR/plugins/*; do
    [[ $file == *.zsh ]] && source $file
done

# Load theme configuration (Goes last)
source $ZDOTDIR/theme/.p10k.zsh
