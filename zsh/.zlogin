if [[ -z "${DISPLAY}" && $XDG_VTNR -eq 1 ]]; then
    sway --unsupported-gpu 2>/dev/null
fi
