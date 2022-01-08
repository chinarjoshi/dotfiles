#!/bin/sh

DOTFILES=$HOME/dotfiles
[[ -z $XDG_CONFIG_HOME ]] && XDG_CONFIG_HOME=$HOME/.config

[ ! $(command -v zsh) ] || echo "Z shell not installed." 1>&2 && exit 1

git clone https://github.com/chinarjoshi/dotfiles.git $DOTFILES

# All directories belong in XDG_CONFIG_HOME except for the following
exclude='wallpapers'
for dir in $(ls -d $DOTFILES/*/ | xargs -n 1 basename); do
    [[ $exclude =~ $dir ]] && 
        ln -sv $DOTFILES/$dir $XDG_CONFIG_HOME/$dir
done
ln -sv $DOTFILES/libinput-gestures.conf $XDG_CONFIG_HOME/libinput-gestures.conf
ln -sv $DOTFILES/.doom.d $HOME/.doom.d

echo "Bootstrapping successful for $USER"
