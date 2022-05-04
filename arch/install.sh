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
    fdisk /dev/sda <<< $FDISK_CMD
    mkfs.fat -F 32 /dev/sda1
    mkfs.ext4 /dev/sda2 /dev/sda3
    mount /dev/sda3 /mnt
    mkdir /mnt/boot /mnt/home
    mount /dev/sda1 /mnt/boot
    mount /dev/sda2 /mnt/home
    fallocate -l $SWAP_SIZE /mnt/swapfile
    mkswap /mnt/swapfile
    chmod 600 /mnt/swapfile
    swapon /mnt/swapfile
}

install_packages() {
    xargs pacstrap /mnt <<< $MAIN_PKG
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
    mkinitcpio -P
    chpasswd <<< 'root:fdsa' 
}

users_systemd_yay() {
    useradd -m c
    EDITOR='tee -a' visudo <<< 'c ALL=(ALL) NOPASSWD: ALL'
    su c -c "git clone https://aur.archlinux.org/yay ~/yay && 
            ~/yay &&
            makepkg -si --noconfirm &&
            xargs yay -S --noconfirm <<< $AUR_PKG &&
            curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh"

    systemctl enable --now NetworkManager systemd-timesyncd
    systemctl set-environment XDG_CURRENT_DESKTOP=sway
}

boot() { # NOT FOR MAC
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
	options root=PARTUUID=$(blkid -s PARTUUID -o value /dev/sda3) rw quiet
EOF
    mkdir -p /etc/systemd/system/getty@tty1.service.d/
    cat <<- EOF > /etc/systemd/system/getty@tty1.service.d/override.conf
	[Service]
	ExecStart=
	ExecStart=-/usr/bin/agetty --autologin c --noclear %I $TERM
EOF
}

mac_specific() { # ONLY FOR MAC
    grub-install --target=x86_64-efi --efi-directory=/dev/sda1 --bootloader-id=GRUB
    grub-mkconfig -o /boot/grub/grub.cfg

    cat <<- EOF > /etc/udev/rules.d/90-cardreader.rules
    SUBSYSTEMS=="usb", ATTRS{idVendor}=="05ac", ATTRS{idProduct}=="8406", RUN+="/usr/local/sbin/remove_ignore_usb-device.sh 05ac 8406"
EOF
    cat <<- EOF > /etc/udev/rules.d/99-bluetooth.rules
    SUBSYSTEMS=="usb", ATTRS{idVendor}=="05ac", ATTRS{idProduct}=="8289", RUN+="/usr/local/sbin/remove_ignore_usb-device.sh 05ac 8289"
    SUBSYSTEMS=="usb", ATTRS{idVendor}=="0a5c", ATTRS{idProduct}=="4500", RUN+="/usr/local/sbin/remove_ignore_usb-device.sh 0a5c 4500"
EOF

    cat <<- EOF > /usr/local/sbin/remove_ignore_usb-device.sh 
    #!/bin/bash
    # shellcheck.net: 4 warnings

    logger -p info "$0 executed."

    if [ "$#" -eq 2 ];then
        
        removevendorid=$1
        removeproductid=$2
        
        usbpath="/sys/bus/usb/devices/"
        devicerootdirs=`ls -1 $usbpath`
        
        for devicedir in $devicerootdirs; do
        
            if [ -f "$usbpath$devicedir/product" ]; then
                product=`cat "$usbpath$devicedir/product"`
                productid=`cat "$usbpath$devicedir/idProduct"`
                vendorid=`cat "$usbpath$devicedir/idVendor"`
                if [ "$removevendorid" == "$vendorid" ] && [ "$removeproductid" == "$productid" ];    then
                    if [ -f "$usbpath$devicedir/remove" ]; then
                        logger -p info "$0 removing $product ($vendorid:$productid)"
                    echo 1 > "$usbpath$devicedir/remove"
                        exit 0
            else
                        logger -p info "$0 already removed $product ($vendorid:$productid)"
                        exit 0
            fi
                fi
            fi
        
        
        done
        
    else
        logger -p err "$0 needs 2 args vendorid and productid"
        exit 1
    fi
EOF

}

symlinks() {
    HOME=/home/c
    DOTFILES=$HOME/dotfiles
    XDG_CONFIG_HOME=$HOME/.config
    mkdir -p $HOME/.config

    git clone https://github.com/chinarjoshi/dotfiles.git $DOTFILES
    chown -R c $DOTFILES

    for dir in $DOTFILES/*/ do
        ln -sv $dir $XDG_CONFIG_HOME/$(basename $dir)
    done
    ln -sv $DOTFILES/zsh/.zshenv $HOME/.zshenv
    ln -sv $DOTFILES/libinput-gestures.conf $XDG_CONFIG_HOME/libinput-gestures.conf

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
      caps_to_escape
      echo "\n---------------------------\nDone :)"
    ;;
    *)
      wifi
      make_filesystems
      install_packages
    ;;
esac
