cat > /etc/wpa_supplicant/wpa_supplicant.conf <<- EOF
network={
    ssid="eduroam"
    key_mgmt=WPA-EAP
    identity="cjoshi44@gatech.edu"
    password="$(cat ~/passwd.sh)"
}
EOF

mount /dev/nvme0n1p2 /mnt/gentoo
mount /dev/nvme0n1p1 /mnt/gentoo/boot
mount --types proc /proc /mnt/gentoo/proc
mount --rbind /dev /mnt/gentoo/dev
mount --rbind /sys /mnt/gentoo/sys
mount --rbind /run /mnt/gentoo/run
chroot /mnt/gentoo /bin/bash
. /etc/profile
