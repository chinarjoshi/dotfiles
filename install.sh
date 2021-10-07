#!/bin/sh

DOTFILES=$HOME/dotfiles
[[ -z $XDG_CONFIG_HOME ]] && XDG_CONFIG_HOME=$HOME/.config

[ ! $(command -v zsh) ] || echo "Z shell not installed." 1>&2 && exit 1

git clone https://github.com/chinarjoshi/dotfiles.git $DOTFILES

# All directories belong in XDG_CONFIG_HOME except for the following
exclude='boot emacs libinput X11'

for dir in $(ls -d $DOTFILES/*/ | xargs -n 1 basename); do
    [[ $exclude =~ $dir ]] && 
        ln -sv $DOTFILES/$dir $XDG_CONFIG_HOME/$dir
done

for X in $(ls -A $DOTFILES/X11); do
    ln -sv $DOTFILES/X11/$X $HOME/$X
done

ln -sv $DOTFILES/emacs $HOME/.doom.d
ln -sv $DOTFILES/libinput/libinput-gestures.conf $XDG_CONFIG_HOME/libinput-gestures.conf
sudo cp $DOTFILES/boot /boot/loader
sudo ln -sv $DOTFILES/libinput/libinput.conf /etc/X11/xorg.conf.d/10-libinput.conf
sudo ln -sv $DOTFILES/libinput/libinput.conf /etc/X11/xorg.conf.d/20-mtrack.conf

echo "Bootstrapping successful for $USER"
