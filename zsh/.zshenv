export DOTFILES=$HOME/dotfiles
export PATH=$PATH:/home/c/.local/bin:/home/c/.local/share/nvim/mason/bin
declare -A env=(
    'EDITOR'               'hx'
    'ZDOTDIR'              "$DOTFILES/zsh"
    'QT_QPA_PLATFORM'      'wayland'
    'XDG_CONFIG_HOME'      "$HOME/.config"
    'XDG_SESSION_TYPE'     'wayland'
    'XDG_CURRENT_DESKTOP'  'sway'
    'ACRONYM_GLOBAL_DIR'   '/home/c/dotfiles'
    'MOZ_ENABLE_WAYLAND'   '1'
    'AUTOENV_ASSUME_YES'   '1'
    'OBSIDIAN_USE_WAYLAND' '1' )
for name value in "${(@kv)env[@]}"; do
    export $name=$value
done
. "$HOME/.cargo/env"
