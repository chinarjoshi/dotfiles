if [[ -z $(playerctl metadata album) ]]; then
    text=$(playerctl metadata --format '  {{ artist }} - {{ title }}')
    tooltip="Playing on youtube"
else
    text=$(playerctl metadata --format ' {{ artist }} - {{ title }} ({{ album }})')
    tooltip="Playing music"
fi

echo $text
echo $tooltip
echo media
