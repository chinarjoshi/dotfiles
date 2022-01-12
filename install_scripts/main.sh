wifi() {
    modprobe -r wl b43 ssb bcma
    modprbe wl
    systemctl restart iwd
    iwctl station wlan0 connect $NETWORK_SSID
}

partition() {
    fdisk
