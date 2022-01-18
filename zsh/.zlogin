if [[ -z "${DISPLAY}" && $XDG_VTNR -eq 1 ]]; then
    exec sway
    swaymsg output "*" scale $([[ $(cat /etc/hostname) == Mac]] && echo 1.6 || echo 1)
fi
