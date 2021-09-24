#! /bin/zsh

DOTFILES=$HOME/dotfiles
[[ -z $XDG_CONFIG_HOME ]] && XDG_CONFIG_HOME=$HOME/.config

git clone https://github.com/chinarjoshi/dotfiles.git $DOTFILES
cd $DOTFILES

echo "export ZDOTDIR=$HOME/dotfiles/zsh" > $HOME/.zshenv

ln -sv $DOTFILES/emacs $HOME/.doom.d

for config in 'nvim' 'alacritty' 'i3'; do
    ln -sv $DOTFILES/$config $XDG_CONFIG_HOME/$config
done

for X in $(ls -A $DOTFILES/X11); do
    ln -sv $DOTFILES/$X $HOME/$X
done

sudo cp $DOTFILES/boot /boot/loader

echo "Bootstrapping successful for $USER"
