### Swaybar config

# Music
music="$(playerctl metadata title 2>/dev/null) - $(playerctl metadata artist 2>/dev/null)"

# Weather
weather=$(cat $DOTFILES/sway/weather.txt)

# Network
ssid=$(iwconfig wlan0 | rg ESSID)
strength=$(sudo iwconfig wlan0 | rg Quality)
strength="$((${strength:23 :-27} * 100 / 70 / 10 * 10))"
network="${ssid:30 :-3} (${strength}%)  "

# Volume
volume="$(pamixer Master --get-volume-human) 墳 "

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
    battery="${charge}% ${battery_icons[$(($charge/20+1))]}$status"
else
    battery=''
fi

date=$(date +"%m/%d %I:%M %p")

# Edge cases
[[ $ssid == "ff/an" ]] && network="Disconnected 睊"
[ -z $(playerctl status 2>/dev/null) ] && music=''

echo "$music  $weather  $network  $volume $battery  $date  "
