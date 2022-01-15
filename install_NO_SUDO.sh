# --------------------- FUNCTIONS -------------------------

wifi() {
    # Disable all network modules and reenable broadcom-wl
    # Then restart iwd and connect to wifi
    modprobe -r wl b43 ssb bcma
    modprobe wl
    systemctl restart iwd
    iwctl station wlan0 connect $NETWORK_SSID
}

partition() {
    echo $FDISK_CMD | fdisk $INSTALL_DISK
}

make_filesystems() {
    mkfs.fat -F 32 ${INSTALL_DISK}1
    mkfs.ext4 ${INSTALL_DISK}2
    mount ${INSTALL_DISK}2 /mnt
    mkdir /mnt/boot
    mount ${INSTALL_DISK}1 /mnt/boot
    fallocate -l $SWAP_SIZE /mnt/swapfile
    mkswap /mnt/swapfile
    swapon /mnt/swapfile
}

install_packages() {
    echo $MAIN_PKG | xargs pacstrap /mnt
    genfstab -U /mnt >> /mnt/etc/fstab
    arch-chroot /mnt                       ### NEW SYSTEM
}

time_lang() {
    timedatectl set-ntp true
    ln -sf /usr/share/zoneinfo/US/Eastern /etc/localtime
    hwclock --systohc
    echo 'en_US.UTF-8 UTF-8' > /etc/locale.gen
    locale-gen
    echo 'LANG=en_US.UTF-8' > /etc/locale.conf
    echo 'c' > /etc/hostname
    mkinitcpio -P
    echo 'root:fdsa' | chpasswd
}


users_systemd() {
    useradd -m c
    echo 'c ALL=(ALL) NOPASSWD: ALL' | EDITOR='tee -a' visudo
    systemctl enable systemd-networkd systemd-resolved iwd
}

yay_install() {
    git clone https://aur.archlinux.org/yay ~/yay
    cd ~/yay
    su c
    makepkg -si
    cd ~
    echo $AUR_PKG | xargs yay -S
    [ $IS_LAPTOP ] && echo $LAPTOP_PKG | xargs yay -S
    exit
}

boot() {
    bootctl install
    echo $LOADER > /boot/loader/loader.conf
    echo $BOOT_ENTRY > /boot/loader/entries/arch.conf
}

symlinks() {
    DOTFILES=$HOME/dotfiles
    XDG_CONFIG_HOME=$HOME/.config
    mkdir $HOME/.config

    git clone https://github.com/chinarjoshi/dotfiles.git $DOTFILES

    for dir in $(ls -d $DOTFILES/*/ | xargs -n 1 basename); do
        ln -sv $DOTFILES/$dir $XDG_CONFIG_HOME/$dir
    done
    ln -sv $DOTFILES/zsh/.zshenv $HOME/.zshenv
    ln -sv $DOTFILES/libinput-gestures.conf $XDG_CONFIG_HOME/libinput-gestures.conf
    ln -sv $DOTFILES/.doom.d $HOME/.doom.d

    echo "Bootstrapping successful for $USER"
}

# ---------------- CONFIGURATION VARIABLES ---------------

IS_LAPTOP=true
NETWORK_SSID=ATT-phanas
INSTALL_DISK=/dev/sda
SWAP_SIZE=10G
FDISK_CMD='g\nn\n1\n\n+300MiB\nn\n2\n\n\nt\n1\n1\nt\n2\n83\nw\nEND' # yes this should be a heredoc, so what

LOADER='default arch.conf
timeout false
console-mode max
editor no'

BOOT_ENTRY="title PenixOS
linux /vmlinuz-linux
initrd /intel-ucode.img
initrd /initramfs-linux.img
options root=PARTUUID=$(blkid -s PARTUUID -o value /dev/sda2) rw quiet acpi_osi=!Darwin"

# --------------- PACKAGES ----------------

MAIN_PKG='
linux
linux-firmware
base
base-devel
amd-ucode
gcc
git
zsh
neovim
man-db
wget

broadcom-wl
iwd
dhcpcd
reflector

xf86-video-nouveau
sway
swayidle
swaylock
waybar
xorg-xwayland
noto-fonts
ttf-nerd-fonts-symbols

pulseaudio
alsa
alsa-utils
pavucontrol
playerctl

alacritty
bat
fzf
fd
ripgrep
ranger
tree
tldr

python
python-pip
clipman'

LAPTOP_PKG='libinput-gestures
light
ydotool'

AUR_PKG='interception-caps2esc
google-chrome
teams
discord_arch_electron
spotify'
