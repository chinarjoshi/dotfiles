# Quick and dirty push changes for solo project
g() {
    git add --all
    git commit -m "$@"
    git pull origin
    git push origin
}

l() {
    unbuffer ls $@ --color=auto -1F | while read line; do echo "| $line"; done
}

ll() {
    unbuffer ls $@ --color=auto -1AF | while read line; do echo "| $line"; done
}

yq() {
    yay --color=auto --noconfirm -Qq | rg "$@"
}

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
zle -N f
bindkey '^f' f

command_not_found_handler() {
    if [[ -o interactive && -w $1 ]]; then
        nvim $1
    else
	    echo ⚠
	    return 1
    fi
}

searchmod() {lsmod | rg $@}

gcl() { git clone https://github.com/$1 }

rs() { rustc $1.rs && ./$1 ${@:2} }

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
