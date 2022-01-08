machine() {
    # To differentiate between computers using machine-id
    [[ $(cat /etc/machine-id) == "$1"* ]]
}

declare -A env=(
    'PATH'           "$HOME/.local/bin:$HOME/.cargo/env:$HOME/.emacs.d/bin:$PATH"
    'EDITOR'          'nvim'
    'ZDOTDIR'          "$HOME/dotfiles/zsh"
    'DOTFILES'          "$HOME/dotfiles"
    'GTK_BACKEND'        'wayland'
    'XDG_CONFIG_HOME'     "$HOME/.config"
    'QT_QPA_PLATFORM'      'wayland-egl'
    'XDG_SESSION_TYPE'      'wayland'
    'MOZ_ENABLE_WAYLAND'     '1'
    'WLR_NO_HARDWARE_CURSORS' '1'
for name dir in "${(@kv)env[@]}"; do
    export $name=$dir
done
. "$HOME/.cargo/env"
