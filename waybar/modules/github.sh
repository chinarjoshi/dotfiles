#!/bin/bash

token=`cat ~/token.txt`
count=`curl -u chinarjoshi:${token} https://api.github.com/notifications | jq '. | length'`

if [[ "$count" != "0" ]]; then
    echo '{"text":'$count',"tooltip":"$tooltip","class":"$class"}'
fi
