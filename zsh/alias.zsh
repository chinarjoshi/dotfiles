# Declares git aliases of the form:
#     alias g{letter} = {command}
# by declaring and looping through an associative array
declare -A git=(
    'a'    'add --all'
    'b'    'branch'
    'c'    'commit -m'
    'd'    'diff'
    'l'    'log --graph --pretty=oneline --decorate --all'
    'm'    'merge'
    's'    'status --short --branch --show-stash'
    'bd'   'branch --delete'
    'ch'   'checkout'
    'pl'   'pull origin'
    'pu'   'push origin'
    'rh'   'reset --hard'
    'rs'   'reset --soft'
    'st'   'stash'
    'chb'  'checkout -b'
    'rea'  'rebase --abort'
    'rec'  'rebase --continue'
    'sta'  'stash apply'
    'stc'  'stash clear'
    'std'  'stash drop'
    'stl'  'stash list'
    'rbc'  'rebase --continue'
    'rba'  'rebase --abort'
    'stp'  'stash pop' )
for letter command in "${(@kv)git[@]}"; do
    alias "g$letter"="git $command"
done

# Declares package manager aliases of the form:
#     alias p{letter} = sudo pacman -{flag}
#     alias y{letter} = yay -{flag}
# by declaring and looping through an associative array of shared flags
declare -A pacman=(
    'i'    'S'
    'ss'   'Ss'
    'sc'   'Sc'
    'r'    'Rs'
    'q'    'Q'
    'u'    'Syu' )
for letter flag in "${(@kv)pacman[@]}"; do
    alias "p$letter"="sudo pacman --color=auto --noconfirm -$flag"
    alias "y$letter"="yay --color=auto --noconfirm -$flag"
done

# Declares pip aliases of the form:
#     alias pi{letter} = pip {command}
declare -A pip=(
    'i'    'install'
    'f'    'freeze'
    'd'    'download'
    'l'    'list'
    'r'    'uninstall' )
for letter command in "${(@kv)pip[@]}"; do
    alias "pi$letter"="pip $command"
done

# Assorted convenience aliases
declare -A etc=(
    'l'        'ls --color=auto -lFgGh'
    'du'       'ncdu'
    'ds'       "$HOME/.emacs.d/bin/doom sync"
    'em'       'emacsclient -c'
    'll'       'ls --color=auto -AlFgGh'
    'py'       'python3'
    'vi'       'nvim'
    'dup'      "$HOME/.emacs.d/bin/doom upgrade"
    'rem'      'killall emacs && emacs --daemon'
    'top'      'htop'
    'clip'     'xclip -selection c'
    'find'     'fd'
    'cpdir'    "echo $PWD | clip"
    'stack'    'search stackoverflow'
    'einit?'   "$EDITOR $HOME/.doom.d/init.el"
    'xinit?'   "$EDITOR $HOME/.xinitrc"
    'github'   'search github'
    'google'   'search google'
    'battery'  'cat /sys/class/power_supply/BAT0/capacity'
    'econfig?' "$EDITOR $HOME/.doom.d/config.el"
    'synonym'  'aiksaurus' )
for key value in "${(@kv)etc[@]}"; do
    alias "$key"="$value"
done

CFG='?'

# Sudo configuration aliases
declare -A sudocfg=(
    'boot'      '/boot/loader/entries/arch.conf'
    'libinput'  '/etc/X11/xorg.conf.d/*' )
for key value in "${(@kv)sudocfg[@]}"; do
    alias "$key$CFG"="sudo $EDITOR $value"
done

# Declares configuration file aliases of the form:
#     alias {dir}cfg = $EDITOR $HOME/.config/{dir}/(* if one file in dir)
# by looping over folders under configuration directory and aliasing {dir}cfg
# to editing the directory if multiple/no files in directory, or the file if
# only one file in directory
for dir in $(ls $HOME/.config | tr -d ' ' | sed '/Microsoft/d'); do
    suffix="$([[ $(ls $HOME/.config/$dir | wc -l) -eq 1 ]] && echo '*')"
    alias "$dir$CFG"="$EDITOR $HOME/.config/$dir/$suffix"
done

# 1. Loop over files in $ZDOTDIR minus markdown or gitignore
# 2. If there are characters before the dot: The alias is the file name
#    Otherwise: The alias is the file extension
# This is long and ugly regex for the sake zsh source files expansion in $ZDOTDIR
for file in $(ls -Ap $ZDOTDIR | grep -Ev '/$|md$|.gitignore'); do
    name="$([[ $(echo $file | sed 's/\..*//' | wc -c) -eq 1 ]] && echo $file | sed 's/\.//' || echo $file | sed 's/\..*//')"
    alias "$name$CFG"="$EDITOR $ZDOTDIR/$file"
done
