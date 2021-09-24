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
source $ZDOTDIR/aliases.zsh
source $ZDOTDIR/functions.zsh

# Source all plugins from directory
plugins=('suggestions' 'jump' 'highlighting' 'pair')
for plugin in $plugins; do
    source $ZDOTDIR/plugins/${plugin}.zsh
done

# Load theme configuration (Goes last)
source $ZDOTDIR/theme/.p10k.zsh
