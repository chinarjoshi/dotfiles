if [[ -z $(playerctl metadata album) ]]; then
    echo $(playerctl metadata --format '  {{ artist }} - {{ title }}')
    echo 'Playing on youtube'
else
    echo $(playerctl metadata --format ' {{ artist }} - {{ title }} ({{ album }})')
    echo 'Playing music'
fi
