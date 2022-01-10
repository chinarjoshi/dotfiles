modprobe -r wl b43 ssb bcma
modprbe wl
systemctl restart iwd
iwctl station wlan0 connect ATT-phanas

read -p "Enter wifi name"

timedatectl set-ntp true

