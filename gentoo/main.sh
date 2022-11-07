set -e

source ./vars.sh

# Network
net-setup $WIFI_IFACE

# Make filesystems
sfdisk /dev/nvme0n1 < $SFDISK
mkfs.fat -F 32 /dev/nvme0n1p1
mkfs.btrfs /dev/nvme0n1p2

fallocate -l 8G /swapfile
chmod 600 /swapfile
mkswap /swapfile

# Mount filesystems
mount /dev/nvme0n1p2 /mnt/gentoo
mount /dev/nvme0n1p1 /mnt/gentoo/boot
swapon /swapfile
cd /mnt/gentoo

# Install stage3
ntpd -q -g
wget $STAGE3_URL
tar xpf stage3-*.tar.xz --xattrs-include='*.*' --numeric-owner

# Prepare for chroot
mirrorselect -i -o >> /mnt/gentoo/etc/portage/make.conf
mkdir --parents /mnt/gentoo/etc/portage/repos.conf
cp /mnt/gentoo/usr/share/portage/config/repos.conf /mnt/gentoo/etc/portage/repos.conf/gentoo.conf
cp --dereference /etc/resolv.conf /mnt/gentoo/etc/
mount --types proc /proc /mnt/gentoo/proc 
mount --rbind /sys /mnt/gentoo/sys
mount --rbind /dev /mnt/gentoo/dev
mount --rbind /run /mnt/gentoo/run

exit

# Chroot
chroot /mnt/gentoo /bin/bash
source /etc/profile

# Setup portage
emerge --sync --quiet
eselect profile set 15
emerge --quiet --update --deep --newuse @world

# Configure the system
cp $FSTAB /etc/fstab
echo "hostname=\"$HOSTNAME\"" >> /etc/conf.d/hostname
cp $HOSTS /etc/hosts
echo "US/Eastern" > /etc/timezone
emerge --config sys-libs/timezone-data
echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen
locale-gen

# User and password
chpasswd < 'root:fdsa'
useradd -m c
usermod -a -G input,video c
EDITOR='tee -a' visudo <<< 'c ALL=(ALL) NOPASSWD: ALL'
chsh -s /bin/zsh c
