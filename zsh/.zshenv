export DOTFILES=$HOME/dotfiles
declare -A env=(
    'PATH'         "$HOME/.local/bin:$HOME/.cargo/bin:$HOME/.local/share/nvim/mason/bin:$PATH"
    'EDITOR'        'nvim'
    'ZDOTDIR'        "$DOTFILES/zsh"
    'CLASSPATH'       '.:/usr/share/java/junit.jar:/usr/share/java/hamcrest-core.jar'
    'GTK_BACKEND'      'wayland'
    'QT_QPA_PLATFORM'    'wayland'
    'GDK_BACKEND'        'wayland'
    'XDG_CONFIG_HOME'     "$HOME/.config"
    'WLR_DRM_DEVICES'      '/dev/dri/card0'
    'XDG_SESSION_TYPE'      'wayland'
    'XDG_RUNTIME_DIR'        '/tmp/sway'
    'XDG_CURRENT_DESKTOP'     'sway'
    'MOZ_ENABLE_WAYLAND'       '1'
    'WLR_NO_HARDWARE_CURSORS'   '1' )
for name value in "${(@kv)env[@]}"; do
    export $name=$value
done
