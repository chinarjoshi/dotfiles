if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

. $ZDOTDIR/theme/powerlevel10k.zsh-theme

# Load plugins
for file in $ZDOTDIR/plugins/*; do
    [[ $file == *.zsh ]] && . $file
done

# Load sensitive data
[[ -f $HOME/passwd.sh ]] && . $HOME/passwd.sh

# Load configuration
for file in $ZDOTDIR/custom/*; do
    . $file
done

# Load Aliases
. ~/.local/lib/python3.10/site-packages/acronym/data/aliases.sh

# Load theme configuration (Goes last)
. $ZDOTDIR/theme/.p10k.zsh
