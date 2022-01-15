set -e
# --------------------- FUNCTIONS -------------------------

wifi() {
    # Disable all network modules and reenable broadcom-wl
    # Then restart iwd and connect to wifi
    modprobe -r wl b43 ssb bcma
    modprobe wl
    [[ $(ip link | grep -c wlan) ]]
    systemctl restart iwd
    iwctl station wlan0 scan
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
    [[ $IS_LAPTOP ]] && echo $LAPTOP_PKG | xargs yay -S
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

alsa_config() {
    amixer sset Master unmute
    amixer sset Speaker unmute
    amixer sset Headphone unmute
    echo $PULSE_CONFIG > /home/c/.config/pulse/daemon.conf
    echo $ALSA_CONFIG > /etc/asound.conf
}

caps_to_escape() {
    echo $CAPS_CONFIG > /etc/interception/udevmon.d/caps2esc.yaml
    systemctl enable udevmon
}

# ---------------- CONFIGURATION VARIABLES ---------------

IS_LAPTOP=true
NETWORK_SSID=ATT-phanas
INSTALL_DISK=/dev/sda
SWAP_SIZE=10G
FDISK_CMD='g\nn\n1\n\n+300MiB\nn\n2\n\n\nt\n1\n1\nt\n2\n83\nw\nEND' # yes this should be a heredoc, so what


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
bat

ntfs-3g
exfat-utils
python
python-pip'

LAPTOP_PKG='libinput-gestures
light
ydotool'

AUR_PKG='interception-caps2esc
google-chrome
teams
discord_arch_electron
clipman
spotify'

# --------------------- FILES ----------------------

# loader.conf
LOADER='default arch.conf
timeout false
console-mode max
editor no'

# arch.conf 
BOOT_ENTRY="title PenixOS
linux /vmlinuz-linux
initrd /intel-ucode.img
initrd /initramfs-linux.img
options root=PARTUUID=$(blkid -s PARTUUID -o value /dev/sda2) rw quiet acpi_osi=!Darwin"

# pulse/daemon.conf
PULSE_CONFIG='
default-sample-format = float32le
default-sample-rate = 48000
alternate-sample-rate = 44100
default-sample-channels = 2
default-channel-map = front-left,front-right
default-fragments = 2
default-fragment-size-msec = 125
resample-method = soxr-vhq
enable-lfe-remixing = no
high-priority = yes
nice-level = -11
realtime-scheduling = yes
realtime-priority = 9
rlimit-rtprio = 9
daemonize = no'

# asound.conf
ALSA_CONFIG='
# Use PulseAudio plugin hw
pcm.!default {
   type plug
   slave.pcm hw
}'

CAPS_CONFIG='
- JOB: "intercept -g $DEVNODE | caps2esc | uinput -d $DEVNODE"
  DEVICE:
    EVENTS:
      EV_KEY: [KEY_CAPSLOCK, KEY_ESC]'

wifi
partition
make_filesystems
install_packages
time_lang
users_systemd
yay_install
boot
symlinks
alsa_config
caps_to_escape
