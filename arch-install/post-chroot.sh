set -e

# Time and lang
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

# Make users, systemd, and yay
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

# Insatll bootloader
bootctl install
cp /arch-install/files/loader.conf /boot/loader/
cp /arch-install/files/arch.conf /boot/loader/entries
PARTUUID=$(blkid -s PARTUUID -o value /dev/nvme0n1p3)
OFFSET=$(sudo filefrag -v /swapfile | rg '(\d{5,})\.' -or '$1' | head -n1)
echo "options root=PARTUUID=$PARTUUID resume=PARTUUID=$PARTUUID resume_offset=$OFFSET rw quiet nvidia-drm.modeset=1 module_blacklist=r8169" >> /boot/loader/entries/arch.conf
mkdir -p /etc/systemd/system/getty@tty1.service.d/
cp /arch-install/files/override.conf /etc/systemd/system/getty@tty1.service.d/

# Dotfiles
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
ln -sv $d/.gitconfig /home/c/.gitconfig

chsh -s /bin/zsh c

# Caps to esc
mkdir -p /etc/interception/udevmon.d/
cp /arch-install/files/caps2esc.yaml /etc/interception/udevmon.d/

# Optimizations
cp -r /arch-install/files/modprobe.d /etc
cp -r /arch-install/files/rules.d /etc/udev/
cpupower frequency-set -g powersave
cpupower set -b 8
cp /usr/share/pipewire/client.conf /etc/pipewire/
cp /usr/share/pipewire/pipewire-pulse.conf /etc/pipewire
sed -i '73s/#//' /etc/pipewire/client.conf
sed -i '59s/#//' /etc/pipewire/pipewire-pulse.conf

echo "\n---------------------------\nDone :)"
