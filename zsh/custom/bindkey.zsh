#zle -N clear_and_ls
#bindkey '^k' clear_and_ls


declare -A names=(
    'clear_and_ls' 'clear && l'
    'git_finish'   'gf'
    'git_status'   'gs' )
for name command in "${(@kv)pacman[@]}"; do
    echo "$name $command"
done
