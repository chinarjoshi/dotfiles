f() {
    tmp="$(mktemp)"
    lf -last-dir-path="$tmp" "$@"
    if [ -f "$tmp" ]; then
        dir="$(cat "$tmp")"
        rm -f "$tmp"
        if [ -d "$dir" ]; then
            if [ "$dir" != "$(pwd)" ]; then
                cd "$dir"
            fi
        fi
    fi
}

g() {
    zle -I
    local file=$(fzf)
    [ -n "$file" ] && $EDITOR "$file"
}

h() {
    (cd ~ && g)
}

zle -N f
bindkey '^f' f

zle -N g
bindkey '^g' g

zle -N h
bindkey '^h' h

# WSL only
# function grab() {
#     cp /mnt/c/Users/china/Downloads/$1 .
# }

command_not_found_handler() {
    if [[ -o interactive && -w $1 ]]; then
        nvim $1
    else
	    echo ⚠
	    return 1
    fi
}

collab() {
    ngrok http 8888 &
    sleep 2
    link=$(curl http://localhost:4040/api/tunnels | rg -o '(https://[^"]+)')
    node ~/projects/discord.js $link
}

_fix_cursor() {
   echo -ne '\e[6 q'
}

precmd_functions+=(_fix_cursor)
