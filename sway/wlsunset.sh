coordinates=$(curl 'https://location.services.mozilla.com/v1/geolocate?key=geoclue' > /dev/null)
lat=$(echo $coordinates | jq '.location.lat')
lng=$(echo $coordinates | jq '.location.lng')
wlsunset -l $lat -L $lng > /dev/null
