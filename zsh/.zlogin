if [ -z "${DISPLAY}" ]; then
    case $XDG_VTNR in 
      1) exec startx ;;
      2) exec sway --unsupported-gpu ;;
    esac
fi
