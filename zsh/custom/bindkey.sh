#! /bin/zsh

declare -A names=(
    'clear_and_ls' 'clear && l'
    'git_finish'   'gf'
    'git_status'   'gs' )
for name command in "${(@kv)pacman[@]}"; do
    $name() { $command }
    zle -N $name
done

bindkey '^k' clear_and_ls
bindkey '^g^g' git_finish
bindkey '^g^s' git_status
