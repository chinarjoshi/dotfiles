# Adds all files to staging area, commits files with date and time, pulls
# changes from remote repository, then pushes changes to remote
g() {
    git add --all
    git commit -m "$([[ $# -eq 0 ]] && $(date +%m-%d) || $@)"
    git pull origin
    git push origin
}

# If dhcpcd.service is active
connect() {
    sudo systemctl restart iwd
    iwctl station wlan0 scan;
    iwctl station wlan0 disconnect;
    iwctl station wlan0 connect $1;
}

search() {
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
    firefox $url
}

command_not_found_handler() {
    if [[ -o interactive && -w $1 ]]; then
        nvim $1
    else
	echo ⚠
	return 1
    fi
}

gcl() { git clone https://github.com/$1 }

rs() { rustc $1.rs && ./$1 ${@:2} }

cpfile() { cat $1 | wl-copy }

cpdir() { echo $PWD | wl-copy }

rt() { mv $@ $HOME/.local/share/Trash }

vpn() { 
    sudo openconnect --csd-wrapper /usr/lib/openconnect/hipreport.sh --protocol=gp https://vpn.gatech.edu <<- EOF
	cjoshi44
	$GT_PASSWD
	push1
	ni-ext-gw.vpn.gatech.edu
	$GT_PASSWD
	push1
	ni-ext-gw.vpn.gatech.edu
EOF
}
