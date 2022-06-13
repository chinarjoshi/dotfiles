set -e

wifi() {
    [[ $(ip link | grep -c wlan) ]] # CHECK IF WIFI INTERFACE IS ACTIVE
    iwctl station wlan0 scan
    iwctl station wlan0 connect $NETWORK_SSID
    echo -e "GET http://google.com HTTP/1.0\n\n" | nc google.com 80 > /dev/null 2>&1 # CHECK IF CONNECTED
}

make_filesystems() {
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
    cp /root/arch-install/files/mkinitcpio.conf > /etc/mkinitcpio.conf
    mkinitcpio -P
    chpasswd <<< 'root:fdsa' 
}

users_systemd_yay() {
    useradd -m c
    usermod -a -G input,video c
    EDITOR='tee -a' visudo <<< 'c ALL=(ALL) NOPASSWD: ALL'
    git clone https://aur.archlinux.org/yay-bin /home/c/yay-bin
    chown -R c /home/c/yay-bin
    rustup install stable
    su c -c "cd ~/yay-bin && makepkg -si --noconfirm"
    xargs yay -S --noconfirm <<< $MAIN_PKG
    for unit in $SYSTEMD_UNITS; do
        systemctl enable --now $unit
    done
}

bootloader() {
    bootctl install
    cp /arch-install/files/loader.conf /boot/loader/
    cp /arch-install/files/arch.conf /boot/loader/entries
    PARTUUID=$(blkid -s PARTUUID -o value /dev/nvme0n1p3)
    OFFSET=$(sudo filefrag -v /swapfile | rg '(\d{5,})\.' -or '$1' | head -n1)
    echo "options root=PARTUUID=$PARTUUID resume=PARTUUID=$PARTUUID resume_offset=$OFFSET rw quiet nvidia-drm.modeset=1 module_blacklist=r8169" >> /boot/loader/entries/arch.conf
    mkdir -p /etc/systemd/system/getty@tty1.service.d/
    cp /arch-install/files/override.conf /etc/systemd/system/getty@tty1.service.d/
}

dotfiles() {
    HOME=/home/c
    d=$HOME/dotfiles
    c=$HOME/.config
    mkdir -p $HOME/.config

    git clone https://github.com/chinarjoshi/dotfiles $d
    rm -rf $d/zsh $d/nvim
    git clone https://github.com/chinarjoshi/zshconf $d/zsh
    git clone https://github.com/chinarjoshi/nvdev $d/nvim
    chown -R c $d

    for dir in $d/*/; do
        ln -sv $dir $c/$(basename $dir)
    done
    ln -sv $d/zsh/.zshenv $HOME/.zshenv
    ln -sv $d/libinput-gestures.conf $c/libinput-gestures.conf
    ln -sv /run/media/c /home/c/usb

    chsh -s /bin/zsh c
}

caps_to_escape() {
    mkdir -p /etc/interception/udevmon.d/
    cp /arch-install/files/caps2esc.yaml /etc/interception/udevmon.d/
}

optimizations() {
    cp -r /arch-install/files/modprobe.d /etc
    cp -r /arch-install/files/rules.d /etc/udev/
    cpupower frequency-set -g powersave
    cpupower set -b 8
    cp /usr/share/pipewire/client.conf /etc/pipewire/
    cp /usr/share/pipewire/pipewire-pulse.conf /etc/pipewire
    sed -i '73s/.*/    resample.quality = 10/' /etc/pipewire/client.conf
    sed -i '59s/.*/    resample.quality = 10/' /etc/pipewire/pipewire-pulse.conf
}

case $1 in
    -chroot)
      . /arch-install/pkgs.sh
      . /arch-install/vars.sh
      time_lang
      users_systemd_yay
      bootloader
      dotfiles
      caps_to_escape
      optimizations
      echo "\n---------------------------\nDone :)"
    ;;
    *)
      . /root/arch-install/pkgs.sh
      . /root/arch-install/vars.sh
      wifi
      make_filesystems
      install_packages
    ;;
esac
