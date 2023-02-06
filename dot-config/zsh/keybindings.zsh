autoload edit-command-line; zle -N edit-command-line
bindkey "^x^e" edit-command-line
bindkey "^xd" fzf-cd-widget
bindkey "^x^f" fzf-file-widget
