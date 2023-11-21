source ~/.cache/p10k-instant-prompt-c.zsh

source $ZDOTDIR/plugins/theme/powerlevel10k.zsh-theme

# Load plugins
for file in $ZDOTDIR/plugins/*; do
    [[ $file == *.zsh ]] && . $file
done

# Load secrets
[[ -f $HOME/passwd.sh ]] && source $HOME/passwd.sh

# Load configuration
for file in $ZDOTDIR/custom/*; do
    source $file
done

# Load theme configuration (Goes last)
source $ZDOTDIR/plugins/theme/.p10k.zsh
