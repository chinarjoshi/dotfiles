# Load cached prompt to speed up initialization (Goes first)
source $ZDOTDIR/theme/instant-prompt.zsh

setopt autocd # cd with path name
unsetopt beep # Inhibit beeping
source $ZDOTDIR/theme/powerlevel10k.zsh-theme

# Append binary user directories to PATH
rust=$HOME/projects/rust
java=$HOME/projects/java

# Source custom aliases && functions
for custom in 'aliases' 'functions'; do
    source $ZDOTDIR/${custom}.zsh
done

# Source all plugins from directory
for plugin in 'suggestions' 'jump' 'highlighting' 'pair'; do
    source $ZDOTDIR/plugins/${plugin}.zsh
done

# Load theme configuration (Goes last)
source $ZDOTDIR/theme/.p10k.zsh
