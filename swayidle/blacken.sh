#!/bin/sh

swaymsg -t get_workspaces | jq '.[] | select(.focused==true) | .num' > ~/dotfiles/swayidle/.workspace
swaymsg 'workspace 6'
