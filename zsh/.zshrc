# Load cached prompt to speed up initialization (Goes first)
source $ZDOTDIR/theme/instant-prompt.zsh

setopt autocd # cd with path name
unsetopt beep # Inhibit beeping
source $ZDOTDIR/theme/powerlevel10k.zsh-theme

# Append binary user directories to PATH
export PATH=$HOME/.emacs.d/bin:$HOME/.local/bin:$PATH
export DOTFILES=$HOME/dotfiles
export EDITOR="nvim"

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
