#!/bin/sh

DOTFILES=$HOME/dotfiles
[[ -z $XDG_CONFIG_HOME ]] && XDG_CONFIG_HOME=$HOME/.config

git clone https://github.com/chinarjoshi/dotfiles.git $DOTFILES

for dir in $(ls -d $DOTFILES/*/ | xargs -n 1 basename); do
    ln -sv $DOTFILES/$dir $XDG_CONFIG_HOME/$dir
done
ln -sv $DOTFILES/zsh/.zshenv $HOME/.zshenv
ln -sv $DOTFILES/libinput-gestures.conf $XDG_CONFIG_HOME/libinput-gestures.conf
ln -sv $DOTFILES/.doom.d $HOME/.doom.d
cat /etc/hostname > $DOTFILES/.identity

echo "Bootstrapping successful for $USER"
