#!/bin/sh
hyprctl activeworkspace -j | jq .id > ~/.workspace
hyprctl --batch "keyword animations:enabled no; dispatch workspace 7"
