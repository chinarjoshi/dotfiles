source ~/.cache/p10k-instant-prompt-c.zsh

source $ZDOTDIR/plugins/theme/powerlevel10k.zsh-theme

# Load plugins
for file in $ZDOTDIR/plugins/*; do
    [[ $file == *.zsh ]] && . $file
done

# Load sensitive data
[[ -f $HOME/passwd.sh ]] && source $HOME/passwd.sh

# Load configuration
for file in $ZDOTDIR/custom/*; do
    source $file
done

alias sudo=doas
alias android="_JAVA_AWT_WM_NONREPARENTING=1 android-studio"

# . ~/.local/lib/python3.10/site-packages/acronym/data/aliases.sh

# Load theme configuration (Goes last)
source $ZDOTDIR/plugins/theme/.p10k.zsh
