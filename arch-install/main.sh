set -e

wifi() {
    # Disable all network modules and reenable broadcom-wl
    # Then restart iwd and connect to wifi
    modprobe -r wl b43 ssb bcma
    modprobe wl
    [[ $(ip link | grep -c wlan) ]] # CHECK IF WIFI INTERFACE IS ACTIVE
    cat <<- EOF > /var/lib/iwd/${NETWORK_SSID}.psk
	[Security]
	Passphrase=$NETWORK_PASSWD
EOF
    systemctl restart iwd
    iwctl station wlan0 scan
    iwctl station wlan0 connect $NETWORK_SSID
    echo -e "GET http://google.com HTTP/1.0\n\n" | nc google.com 80 > /dev/null 2>&1 # CHECK IF CONNECTED
}

make_filesystems() {
    fdisk <<< $FDISK_CMD
    mount /dev/sda3 /mnt
    mkdir -p /mnt/boot /mnt/home
    mount /dev/sda1 /mnt/boot
    mount /dev/sda2 /mnt/home
    fallocate -l $SWAP_SIZE /mnt/swapfile
    mkswap /mnt/swapfile
    chmod 0600 /mnt/swapfile
    swapon /mnt/swapfile
}

install_packages() {
    xargs pacstrap /mnt <<< $BASE_PKG
    genfstab -U /mnt >> /mnt/etc/fstab
    cp /root/arch-install /mnt -r
    arch-chroot /mnt /bin/bash /arch-install/$0 -chroot       ### NEW SYSTEM
}

time_lang() {
    timedatectl set-ntp true
    ln -sf /usr/share/zoneinfo/US/Eastern /etc/localtime
    hwclock --systohc
    echo 'en_US.UTF-8 UTF-8' > /etc/locale.gen
    locale-gen
    echo 'LANG=en_US.UTF-8' > /etc/locale.conf
    echo $HOSTNAME > /etc/hostname
    mkinitcpio -P
    chpasswd <<< 'root:fdsa' 
}

users_systemd_yay() {
    useradd -m c
    EDITOR='tee -a' visudo <<< 'c ALL=(ALL) NOPASSWD: ALL'
    git clone https://aur.archlinux.org/yay /home/c/yay
    chown -R c /home/c/yay
    su c -c "~/yay && makepkg -si --noconfirm"
    xargs yay -S --noconfirm <<< $MAIN_PKG
    systemctl enable --now NetworkManager systemd-timesyncd tlp
}

boot() {
    bootctl install
    cat <<- EOF > /boot/loader/loader.conf
	default arch.conf
	timeout false
	console-mode max
	editor no
EOF
    cat <<- EOF > /boot/loader/entries/arch.conf
	title Arch Linux
	linux /vmlinuz-linux
	initrd /intel-ucode.img
	initrd /initramfs-linux.img
	options root=PARTUUID=$(blkid -s PARTUUID -o value /dev/sda3) rw quiet nvidia-drm.modeset=1
EOF
    mkdir -p /etc/systemd/system/getty@tty1.service.d/
    cat <<- EOF > /etc/systemd/system/getty@tty1.service.d/override.conf
	[Service]
	ExecStart=
	ExecStart=-/usr/bin/agetty --autologin c --noclear %I $TERM
EOF
}

symlinks() {
    HOME=/home/c
    DOTFILES=$HOME/dotfiles
    XDG_CONFIG_HOME=$HOME/.config
    mkdir -p $HOME/.config

    git clone https://github.com/chinarjoshi/dotfiles.git $DOTFILES
    chown -R c $DOTFILES

    for dir in $DOTFILES/*/; do
        ln -sv $dir $XDG_CONFIG_HOME/$(basename $dir)
    done
    ln -sv $DOTFILES/zsh/.zshenv $HOME/.zshenv
    ln -sv $DOTFILES/libinput-gestures.conf $XDG_CONFIG_HOME/libinput-gestures.conf
    ln -sv /run/media/c /home/c/mnt

    chsh -s /bin/zsh c
}

caps_to_escape() {
    mkdir -p /etc/interception/udevmon.d/
    cat <<- EOF > /etc/interception/udevmon.d/caps2esc.yaml
	- JOB: \"intercept -g $DEVNODE | caps2esc | uinput -d $DEVNODE\"
	  DEVICE:
	    EVENTS:
      EV_KEY: [KEY_CAPSLOCK, KEY_ESC]
EOF
    systemctl enable udevmon
}

case $1 in
    -chroot)
      time_lang
      users_systemd_yay
      mac_specific
      symlinks
      caps_to_escape
      echo "\n---------------------------\nDone :)"
    ;;
    *)
      wifi
      make_filesystems
      install_packages
    ;;
esac
