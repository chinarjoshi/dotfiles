if [ -z "${DISPLAY}" ] && [ "${XDG_VTNR}" -eq 1 ]; then
    exec startx
fi

if [ -z "${DISPLAY}" ] && [ "${XDG_VTNR}" -eq 2 ]; then
    exec sway --unsupported-gpu
fi
