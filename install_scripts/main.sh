wifi() {
    modprobe -r wl b43 ssb bcma
    modprbe wl
    systemctl restart iwd
    iwctl station wlan0 connect $NETWORK_SSID
}

partition() {
    parted mklabel gpt
    parted mkpart primary fat32 start
