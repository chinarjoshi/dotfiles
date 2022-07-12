#! /usr/bin/python3

import datetime
from astral import Observer
from astral.sun import sun

hour = datetime.datetime.now().hour

def utc_to_east(date: datetime.datetime) -> float:
    h = date.hour - 4
    h = h if h >= 0 else 24 + h
    return round(h + date.minute / 60, 2)

me = Observer(latitude=33.75, longitude=-84.38, elevation=0.0)
t = {k: utc_to_east(v) for k, v in sun(me, date=datetime.date(2022, 7, 4)).items()}

if t['sunrise'] < hour and hour < t['noon'] - 1.5:
    time = 'morning' 
elif t['noon'] - 1.5 < hour and hour < t['sunset'] - 3:
    time = 'afternoon'
elif t['sunset'] - 3 < hour and hour < t['dusk'] - .5:
    time = 'evening'
else:
    time = 'night'

with open('/home/c/dotfiles/sway/custom/wallpaper.conf', 'w') as f:
    f.write(f'output * bg ~/dotfiles/sway/wallpapers/{time} fill')
