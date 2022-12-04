if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

. $ZDOTDIR/plugins/theme/powerlevel10k.zsh-theme

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

alias reboot="doas runit-init 6"
alias poweroff="doas runit-init 0"
alias sudo="doas"
alias sleep="sudo su root -c 'echo mem > /sys/power/state'"

# Load theme configuration (Goes last)
. $ZDOTDIR/plugins/theme/.p10k.zsh

export CLASSPATH=~/Downloads/junit-4.12.jar:~/Downloads/hamcrest-core-1.3.jar
