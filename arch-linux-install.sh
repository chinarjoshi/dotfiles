set -e

HOSTNAME=Mac
NETWORK_SSID=ATT-phanas
NETWORK_PASSWD=6080700101
SWAP_SIZE=18G
FDISK_CMD="g
n


+256MiB
y
n


+64GiB
y
n



y

t
1
1

t
2
20

t
3
20

w
"

BASE_PKG='
linux
linux-firmware
base
base-devel
'

MAIN_PKG='
git
zsh
grub
efibootmgr
intel-ucode
acpi

broadcom-wl
networkmanager
network-manager-applet
reflector

nvidia
opencl-nvidia
sway
xorg-xwayland
xf86-video-intel
libinput-gestures
interception-caps2esc
swaylock
clipman
qt6-wayland
mesa
mako
waybar

noto-fonts
ttf-dejavu
gnu-free-fonts
nerd-fonts-noto

pipewire
pipewire-alsa
pipewire-pulse
wireplumber
alsa-utils
playerctl

alacritty
neovim
bat
fzf
fd
lf
jq
ripgrep
tree
tldr
curl
wget
cronie
man-db
git-delta

grim
slurp
wf-recorder
xdg-desktop-portal
xdg-desktop-portal-wlr
autotiling-rs-git

tlp
ntfs-3g
exfat-utils
dosfstools
usbutils
light
acpilight
wlsunset
cups
cups-pdf
npm
ctags

firefox
google-chrome
discord-qt-appimage
spotify
ydotool

python
python-pip
flake8
lua
luacheck
luarocks
stylua
jdk-openjdk
ruby
php
julia
prettier
pandoc
black
isort
neovim-sniprun
nvim-packer-git
'

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
    mount /dev/sda4 /mnt
    mkdir -p /mnt/boot /mnt/home
    mount /dev/sda1 /mnt/boot
    mount /dev/sda3 /mnt/home
    fallocate -l $SWAP_SIZE /mnt/swapfile
    mkswap /mnt/swapfile
    chmod 0600 /mnt/swapfile
    swapon /mnt/swapfile
}

reset() {
    umount /mnt/boot /mnt/home
    swapoff /mnt/swapfile
    rm -rf * /mnt/*
    umount /mnt
}

install_packages() {
    xargs pacstrap /mnt <<< $BASE_PKG
    genfstab -U /mnt >> /mnt/etc/fstab
    cp /root/arch /mnt -r
    arch-chroot /mnt /bin/bash /arch/$0 -chroot       ### NEW SYSTEM
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
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
    systemctl enable --now NetworkManager systemd-timesyncd tlp
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
    mkdir /boot/efi/EFI/custom
    curl -L https://github.com/0xbb/apple_set_os.efi/releases/download/v1/apple_set_os.efi > /boot/efi/EFI/custom
    cat <<- EOF > /boot/grub/custom.cfg
	search --no-floppy --set=root --label EFI
	chainloader(${root})/EFI/custom/epple_set_os.efi
	boot
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
      # wifi
      make_filesystems
      install_packages
    ;;
esac
