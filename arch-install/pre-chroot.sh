set -e

# Wifi
[[ $(ip link | grep -c wlan) ]] # CHECK IF WIFI INTERFACE IS ACTIVE
iwctl station wlan0 scan
iwctl station wlan0 connect $NETWORK_SSID
echo -e "GET http://google.com HTTP/1.0\n\n" | nc google.com 80 > /dev/null 2>&1 # CHECK IF CONNECTED

# Make filesystems
fdisk $DISK <<< $FDISK_CMD
mkfs.fat -F32 $BOOT
mkfs.ext4 $HOME
mkfs.ext4 $ROOT
mount $ROOT /mnt
mkdir -p /mnt/boot /mnt/home
mount $BOOT /mnt/boot
mount $HOME /mnt/home
fallocate -l $SWAP_SIZE /mnt/swapfile
mkswap /mnt/swapfile
chmod 0600 /mnt/swapfile
swapon /mnt/swapfile

# Install packages
xargs pacstrap /mnt <<< $BASE_PKG
genfstab -U /mnt >> /mnt/etc/fstab
cp /root/arch-install /mnt -r
arch-chroot /mnt /bin/bash /arch-install/$0 -chroot       ### NEW SYSTEM
