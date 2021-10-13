#!/usr/bin/env bash

if [[ $(pidof polybar) ]]; then
    killall -q polybar
else
    polybar desktop 2>&1 | tee -a /tmp/polybar1.log & disown
fi
