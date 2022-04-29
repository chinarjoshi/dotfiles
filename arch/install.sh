set -e

. pkg.sh
. var.sh

wifi() {
    # Disable all network modules and reenable broadcom-wl
    # Then restart iwd and connect to wifi
    modprobe -r wl b43 ssb bcma
    modprobe wl
    [[ $(ip link | grep -c wlan) ]]
    cat <<- EOF > /var/lib/iwd/${NETWORK_SSID}.psk
	[Security]
	Passphrase=$NETWORK_PASSWD
EOF
    systemctl restart iwd
    iwctl station wlan0 scan
    iwctl station wlan0 connect $NETWORK_SSID
}

make_filesystems() {
    echo $FDISK_CMD | fdisk $INSTALL_DISK
    mkfs.fat -F 32 ${INSTALL_DISK}1
    mkfs.ext4 ${INSTALL_DISK}2
    mount ${INSTALL_DISK}2 /mnt
    mkdir /mnt/boot
    mount ${INSTALL_DISK}1 /mnt/boot
    fallocate -l $SWAP_SIZE /mnt/swapfile
    mkswap /mnt/swapfile
    chmod 600 /mnt/swapfile
    swapon /mnt/swapfile
}

install_packages() {
    sed -i '93,94s/#//' /mnt/etc/pacman.conf # Uncomment multilib repo
    echo $MAIN_PKG | xargs pacstrap /mnt
    genfstab -U /mnt >> /mnt/etc/fstab
    cp /root/**/$0 /mnt/$0
    arch-chroot /mnt /bin/bash /$0 -chroot       ### NEW SYSTEM
}

time_lang() {
    timedatectl set-ntp true
    ln -sf /usr/share/zoneinfo/US/Eastern /etc/localtime
    hwclock --systohc
    echo 'en_US.UTF-8 UTF-8' > /etc/locale.gen
    locale-gen
    echo 'LANG=en_US.UTF-8' > /etc/locale.conf
    echo $HOSTNAME > /etc/hostname
    mkdir -p /var/lib/iwd/
    cat <<- EOF > /var/lib/iwd/${NETWORK_SSID}.psk
	[Security]
	Passphrase=$NETWORK_PASSWD
EOF
    cat <<- EOF > /etc/systemd/network/wireless.network
	[Match]
	Name=wlan0

	[Network]
	DHCP=yes
EOF
    mkinitcpio -P
    echo 'root:fdsa' | chpasswd
}

users_systemd_yay() {
    useradd -m c
    echo 'c ALL=(ALL) NOPASSWD: ALL' | EDITOR='tee -a' visudo
    git clone https://aur.archlinux.org/yay /home/c/yay
    /home/c/yay
    su c -c "makepkg -si --noconfirm && echo $AUR_PKG | xargs yay -S --noconfirm"
    su c -c "curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh"

    systemctl enable --now NetworkManager systemd-timesyncd bluetooth
    systemctl set-environment XDG_CURRENT_DESKTOP=sway
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
	title ChinArch Linux
	linux /vmlinuz-linux
	initrd /${CPU_TYPE}-ucode.img
	initrd /initramfs-linux.img
	options root=PARTUUID=$(blkid -s PARTUUID -o value /dev/sda2) rw quiet $($IS_LAPTOP && echo acpi_osi=!Darwin)
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

    for dir in $(ls -d $DOTFILES/*/ | xargs -n 1 basename); do
        ln -sv $DOTFILES/$dir $XDG_CONFIG_HOME/$dir
    done
    ln -sv $DOTFILES/zsh/.zshenv $HOME/.zshenv
    ln -sv $DOTFILES/libinput-gestures.conf $XDG_CONFIG_HOME/libinput-gestures.conf
    ln -sv $DOTFILES/.doom.d $HOME/.doom.d

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
      boot
      symlinks
      alsa_config
      caps_to_escape
      xdg-wlr
      echo "\n---------------------------\nDone :)"
    ;;
    *)
      wifi
      make_filesystems
      install_packages
    ;;
esac
