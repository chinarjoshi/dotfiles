artist=$(playerctl metadata artist 2>/dev/null)
title=$(playerctl metadata title 2>/dev/null)
album=$(playerctl metadata album 2>/dev/null)
if [[ ! -z $album ]]; then
    album="- $album "
else
    album=''
fi

[ -z $(playerctl status 2>/dev/null) ] || echo "$title ﱘ $album ($artist ﴁ)"
