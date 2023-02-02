# +---------+
# | General |
# +---------+

# Load more completions
#fpath=($DOTFILES/zsh/plugins/zsh-completions/src $fpath)

# Should be called before compinit
zmodload zsh/complist

autoload -U colors && colors
autoload -U compinit; compinit
_comp_options+=(globdots) # With hidden files

# Only work with the Zsh function vman
# See $DOTFILES/zsh/scripts.zsh
compdef vman="man"

bindkey '^[[Z' reverse-menu-complete

# +---------+
# | Options |
# +---------+

#setopt GLOB_COMPLETE      # Show autocompletion menu with globs
#setopt MENU_COMPLETE        # Automatically highlight first element of completion menu
setopt AUTO_LIST            # Automatically list choices on ambiguous completion.
setopt COMPLETE_IN_WORD     # Complete from both ends of a word.


# +---------+
# | zstyles |
# +---------+

# Ztyle pattern
# :completion:<function>:<completer>:<command>:<argument>:<tag>

# Define completers
zstyle ':completion:*' special-dirs true
zstyle ':completion:*' completer _extensions _complete _approximate

# Use cache for commands using cache
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path "$XDG_CACHE_HOME/zsh/.zcompcache"

# Complete the alias when _expand_alias is used as a function
zstyle ':completion:*' complete true

zle -C alias-expension complete-word _generic
zstyle ':completion:alias-expension:*' completer _expand_alias

# Use cache for commands which use it

# Allow you to select in a menu
zstyle ':completion:*' menu select

# Autocomplete options for cd instead of directory stack
zstyle ':completion:*' complete-options true
zstyle ':completion:*' file-sort modification


# zstyle ':completion:*:*:*:*:corrections' format '%F{yellow}!- %d (errors: %e) -!%f'
# zstyle ':completion:*:*:*:*:descriptions' format '%F{blue}-- %D %d --%f'
# zstyle ':completion:*:*:*:*:messages' format ' %F{purple} -- %d --%f'
# zstyle ':completion:*:*:*:*:warnings' format ' %F{red}-- no matches found --%f'

zstyle ':completion:*:default' list-prompt "%S%M matches%s"
# Colors for files and directory
zstyle ':completion:*:*:*:*:default' list-colors "${(s.:.)LS_COLORS}" # %{$reset_color%}

# Only display some tags for the command cd
zstyle ':completion:*:*:cd:*' tag-order local-directories directory-stack path-directories special-dirs
#zstyle ':completion:*:complete:git:argument-1:' tag-order !aliases

# Required for completion to be in good groups (named after the tags)
zstyle ':completion:*' group-name ''

zstyle ':completion:*:*:-command-:*:*' group-order aliases builtins functions commands

# See ZSHCOMPWID "completion matching control"
zstyle ':completion:*' matcher-list '' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'

zstyle ':completion:*' keep-prefix true

zstyle -e ':completion:*:(ssh|scp|sftp|rsh|rsync):hosts' hosts 'reply=(${=${${(f)"$(cat {/etc/ssh_,~/.ssh/known_}hosts(|2)(N) /dev/null)"}%%[# ]*}//,/ })'

zstyle -e ':completion:*:(ssh|scp|sftp|rsh|rsync):hosts' hosts 'reply=(${=${${(f)"$(cat {/etc/ssh_,~/.ssh/known_}hosts(|2)(N) /dev/null)"}%%[# ]*}//,/ })'

#          #0,-#1,#2,#3 #4                       #5      #6    #7
zstyle -e ':completion:*:(ssh|scp|sftp|rsh|rsync):hosts' hosts 'reply=(${=${${(f)"$(cat {/etc/ssh_,~/.ssh/known_}hosts(|2)(N) /dev/null)"}%%[# ]*}//,/ })'
#0 -- namespace for zstyle patterns. Apply style to:
# Fehlen:
#1 -- function: an external shell function or "widget" (concerned with shell functionality)
#2 -- completer: a specific completion function (drop the _)
#3 -- command: a shell command like cd or a cmdline tool like sed
# Sind da
#4 -- argument: the nth sub-command/option/argument
#5 -- tag: a specific kind of match: files, domains, users, options: (try files before directories...)

#6 -- the style: verbose/hosts


if [ -d $XDG_CONFIG_HOME/guix/current/share/zsh/site-functions ]; then
    for file in $XDG_CONFIG_HOME/guix/current/share/zsh/site-functions/**; do
        [ -f "$file" ] && source "$file" 2> /dev/null
    done
fi

zstyle -e ':completion:*:guix_command:guix:*:commands' verbose yes
zstyle -e ':completion:*:guix_system:guix:system:(commands|arguments)' menu
zstyle -e ':completion:*:guix_refresh:guix:refresh:(arguments|updaters|packages)' menu
zstyle -e ':completion:*:guix_size:guix:size:(arguments|packages)' menu
zstyle -e ':completion:*:guix_pull:guix:pull:arguments' menu
zstyle -e ':completion:*:guix_publish:guix:publish:arguments' menu
zstyle -e ':completion:*:guix_upgrade:guix:upgrade:arguments' menu
zstyle -e ':completion:*:guix_remove:guix:remove:(arguments|packages)' menu
zstyle -e ':completion:*:guix_install:guix:install:(arguments|packages)' menu
zstyle -e ':completion:*:guix_package:guix:package:(arguments|install|show|remove)' menu
zstyle -e ':completion:*:guix_lint:guix:lint:(packages|checkers|arguments)' menu
zstyle -e ':completion:*:guix_import:guix:import:(arguments|importer)' menu

zstyle -e ':completion:*:guix_hash:guix:hash:arguments' menu
zstyle -e ':completion:*:guix_hash:guix:hash:*' completer _complete _approximate

zstyle -e ':completion:*:guix_graph:guix:graph:(arguments|types|packages)' menu

zstyle -e ':completion:*:guix_gc:guix:gc:arguments' menu
zstyle -e ':completion:*:guix_gc:guix:gc:' completer _complete _approximate

zstyle -e ':completion:*:guix_environment:guix:environment:(arguments|packages)' menu

zstyle -e ':completion:*:guix_edit:guix:edit:packages' menu

zstyle -e ':completion:*:guix_download:guix:download:arguments' menu
zstyle -e ':completion:*:guix_download:guix:download:urls' menu

zstyle -e ':completion:*:guix_container:guix:container:*' "exec"
# zstyle -e ':completion:*:guix_installed_packages:guix package:-I:(arguments|packages)' menu
