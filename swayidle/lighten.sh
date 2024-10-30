#!/bin/sh
hyprctl dispatch workspace $(cat ~/.workspace)
sleep 1
hyprctl keyword animations:enabled yes
