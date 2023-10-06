alias cfgadm="/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME"
alias clip='xargs echo -n | wl-copy'
alias dired='emacsclient -t -e "(dired  \"./\")"'
alias dus='du -sh * | sort -rh'
alias magit='emacsclient -t -e "(magit  \"./\")"'
alias pdfjoin='pdfjam --fitpaper true --rotateoversize false'
alias rs="rsync --update --progress --recursive"
alias temacs='emacsclient --tty'
alias flatpak='flatpak --user'
alias journal_sway='journalctl --user --follow --this-boot --identifier sway'
alias jrn='journalctl --user --follow --this-boot --unit'
alias sys='systemctl --user'
alias ip='ip --color=auto'
alias rcom='sudo picocom --baud 115200 --escape t /dev/ttyUSB0'
alias pacman-package-fzf="pacman -Qq | fzf --preview 'pacman -Qil {}' --layout=reverse --bind 'enter:execute(pacman -Qil {} | less)'"
