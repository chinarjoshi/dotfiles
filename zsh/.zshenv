machine() {
    # To differentiate between computers using machine-id
    [[ $(cat /etc/machine-id) == "$1"* ]]
}

declare -A env=(
    'PATH'            "$HOME/.local/bin:$HOME/.cargo/env:$HOME/.emacs.d/bin:$PATH"
    'EDITOR'          'nvim'
    'ZDOTDIR'         "$HOME/dotfiles/zsh"
    'DOTFILES'        "$HOME/dotfiles"
    'XDG_CONFIG_HOME' "$HOME/.config"
    'MAC'             "$(machine 411; echo $?)"
    'DESKTOP'         "$(machine 301; echo $?)" )
for name dir in "${(@kv)env[@]}"; do
    export $name=$dir
done
. "$HOME/.cargo/env"
