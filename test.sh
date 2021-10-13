#!/bin/sh

[ ! $(command -v zsh) ] || echo "Z shell not installed." 1>&2 && exit 1

# All directories belong in XDG_CONFIG_HOME except for the following
exclude='boot emacs libinput X11'

for dir in $(ls -d $DOTFILES/*/ | xargs -n 1 basename); do
    [[ ! $exclude =~ $dir ]] && 
	    echo $dir
done

for X in $(ls -A $DOTFILES/X11); do
	echo $X
done

ln -sv $DOTFILES/emacs $HOME/.doom.d
ln -sv $DOTFILES/libinput/libinput-gestures.conf $XDG_CONFIG_HOME/libinput-gestures.conf
sudo cp $DOTFILES/boot /boot/loader
sudo ln -sv $DOTFILES/libinput/libinput.conf /etc/X11/xorg.conf.d/10-libinput.conf
sudo ln -sv $DOTFILES/libinput/libinput.conf /etc/X11/xorg.conf.d/20-mtrack.conf

echo "Bootstrapping successful for $USER"
