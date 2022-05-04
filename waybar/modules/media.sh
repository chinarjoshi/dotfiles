if [[ -z $(playerctl metadata artist) ]]; then
    if [[ $(playerctl metadata title) == *'Hulu'* ]]; then
        echo 'ﴧ  Hulu'
        echo 'Playing on Hulu'
    elif [[ $(playerctl metadata title) == *'Netflix'* ]]; then
        echo 'ﱄ  Netflix'
        echo 'Playing on Netflix'
    fi
elif [[ -z $(playerctl metadata album) ]]; then
    echo $(playerctl metadata --format '  {{ artist }} - {{ title }}')
    echo 'Playing on youtube'
else
    echo $(playerctl metadata --format ' {{ artist }} - {{ title }} ({{ album }})')
    echo 'Playing music'
fi
