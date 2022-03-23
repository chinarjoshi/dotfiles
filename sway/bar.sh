### Swaybar config

# Music
artist=$(playerctl metadata artist 2>/dev/null)
title=$(playerctl metadata title 2>/dev/null)
album=$(playerctl metadata album 2>/dev/null)
if [[ ! -z $album ]]; then
    album="- $album "
fi

music="$title ﱘ $album ($artist ﴁ)  ▏"

# Weather
weather=$(cat $DOTFILES/sway/weather.txt | xargs)

# Network
ssid=$(iwconfig wlan0 | rg ESSID)
strength=$(sudo iwconfig wlan0 | rg Quality)
if [[ ! -z $strength ]]; then
    strength="$((${strength:23 :-27} * 100 / 70 / 10 * 10))"
    network="${ssid:30 :-3} (${strength}%)  "
else
    network="Disconnected (0%) 睊"
fi

# Volume
volume="$(pamixer Master --get-volume-human) 墳"

# Battery if laptop
if [ $(cat /etc/hostname) != "Desktop" ]; then
    battery_icons=(
      ' '
      ' '
      ' '
      ' '
      ' '
    )
    charge=$(cat /sys/class/power_supply/BAT0/capacity)
    status=$([[ $(cat /sys/class/power_supply/BAT0/status) = "Charging" ]] && echo ' ⚡')
    battery="▏${charge}% ${battery_icons[$(($charge/20+1))]}$status"
else
    battery=''
fi

date=$(date +"%m/%d %I:%M %p")

# Edge cases
[[ $ssid == "ff/an" ]] && network="Disconnected 睊"
[ -z $(playerctl status 2>/dev/null) ] && music=''

echo "$music $weather  ▏ $network ▏ $volume $battery ▏ $date  "
