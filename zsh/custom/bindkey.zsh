# Command to function
clear_and_ls() { clear && l }
git_finish() { gf }
git_status() { gs }

# Function to widget
zle -N clear_and_ls
zle -N git_finish
zle -N git_status

# Widget to shortcut
bindkey '^k' clear_and_ls
bindkey '^g^g' git_finish
bindkey '^g^s' git_status
