### Swaybar config

# Music
music="$(playerctl metadata title) - $(playerctl metadata artist)"

# Weather
weather=$(cat weather.txt)

# Network
ssid=$(iwconfig wlan0 | rg ESSID)
strength=$(sudo iwconfig wlan0 | rg Quality)
strength="$((${strength:23 :-27} * 100 / 70 / 10 * 10))"
network="${ssid:30 :-3} (${strength}%)  "

# Volume
volume="$(pamixer Master --get-volume-human) 墳"

# Battery if laptop
if [ $(cat /etc/hostname) != "Desktop" ]; then
    charge=$(cat /sys/class/power_supply/BAT0/capacity)
    status=$([[ $(cat /sys/class/power_supply/BAT0/status) = "Charging" ]] && echo '⚡')
    battery="${charge}% $battery_icons[$(($charge/20+1))] $status"
else
    battery=''
fi

battery_icons=(
  ' '
  ' '
  ' '
  ' '
  ' '
)

date=$(date +"%m/%d %H:%M")

# Edge cases
[[ $ssid == "ff/an" ]] && network="Disconnected 睊"
[ -z $(playerctl status) ] && music=''

echo "$music  $weather  $network  $volume $battery  $date  "
