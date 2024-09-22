alias cfgadm="/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME"
alias clip='xargs echo -n | wl-copy'
alias dired='emacsclient -t -e "(dired  \"./\")"'
alias dus='du -sh * | sort -rh'
alias ip='ip --color=auto'
alias journal_sway='journalctl --user --follow --this-boot --identifier sway'
alias jrn='journalctl --user --follow --this-boot --unit'
alias lsless='ls -lah --color=always --group-directories-first --indicator-style=slash | less -R --use-color'
alias magit='emacsclient -t -e "(magit  \"./\")"'
alias pacman-package-fzf="pacman -Qq | fzf --preview 'pacman -Qil {}' --layout=reverse --bind 'enter:execute(pacman -Qil {} | less)'"
alias pdfjoin='pdfjam --fitpaper true --rotateoversize false'
alias rcom='sudo picocom --baud 115200 --escape t /dev/ttyUSB0'
alias rs="rsync --update --progress --recursive"
alias ssys='sudo systemctl'
alias sys='systemctl --user'
alias temacs='emacsclient --tty'
alias fd='cd "$(find ~/* -type d | fzf)"'
alias lfd='cd "$(find * -type d | fzf)"'
