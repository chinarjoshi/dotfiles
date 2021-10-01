declare -A env=(
    'PATH'            "$HOME/.local/bin:$HOME/.cargo/env:$PATH"
    'EDITOR'          'nvim'
    'ZDOTDIR'         "$HOME/dotfiles/zsh"
    'DOTFILES'        "$HOME/dotfiles"
    'XDG_CONFIG_HOME' "$HOME/.config" )
for name dir in "${(@kv)env[@]}"; do
    export $name=$dir
done


