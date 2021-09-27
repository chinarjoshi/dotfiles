# Adds all files to staging area, commits files with date and time, pulls
# changes from remote repository, then pushes changes to remote
function fuckit() {
    git add --all
    git commit -m "$(date)"
    git pull origin
    git push origin
}

# If dhcpcd.service is active
function connect() {
    if [ $(systemctl status | rg dhcpcd.service | wc -l) -eq 2 ]; then
        iwctl station wlan0 scan;
        iwctl station wlan0 disconnect;
        iwctl station wlan0 connect $1;
    fi
}

function search() {
    typeset -A urls=(
        google      "https://www.google.com/search?q="
        github      "https://github.com/search?q="
        stackoverflow  "https://stackoverflow.com/search?q=" )

    # check whether the search engine is supported
    if [[ -z "$urls[$1]" ]]; then
        echo "Search engine '$1' not supported."
        return 1
    fi    

    # search or go to main page depending on number of arguments passed
    if [[ $# -gt 1 ]]; then
        url="${urls[$1]}${(j:+:)@[2,-1]}"
    else
        url="${(j://:)${(s:/:)urls[$1]}[1,2]}"
    fi    

    google-chrome-stable "$url"
}

function gcl() {
    git clone https://github.com/$1
}

function rust() {
    rustc $1.rs && ./$1
}
