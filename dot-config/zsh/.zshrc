# echo "sourcing $ZDOTDIR/.zshrc"

# For Emacs tramp to work:
[[ $TERM == "dumb" ]] && unsetopt zle && PS1='$ ' && return

bindkey -e

if ! [ -d "${XDG_CACHE_HOME:-$HOME/.cache}/zsh" ]; then
   mkdir --parents -v "${XDG_CACHE_HOME:-$HOME/.cache}/zsh"
fi

HISTFILE="${XDG_CACHE_HOME:-$HOME/.cache}/zsh/zsh_history"
HISTSIZE=2000
SAVEHIST=2000
setopt sharehistory

autoload -U compinit; compinit
_comp_options+=(globdots)

# global customizations
[ -f "$ZDOTDIR/completions.zsh" ] && source "$ZDOTDIR/completions.zsh"
[ -f "$ZDOTDIR/prompt.zsh" ] && source "$ZDOTDIR/prompt.zsh"
[ -f "$ZDOTDIR/keybindings.zsh" ] && source "$ZDOTDIR/keybindings.zsh"
[ -f "$HOME/.bash_aliases" ] && source "$HOME/.bash_aliases"
[ -f "$HOME/.bash_functions" ] && source "$HOME/.bash_functions"
[ -f "$ZDOTDIR/aliases.zsh" ] && source "$ZDOTDIR/aliases.zsh"
[ -f "$ZDOTDIR/functions.zsh" ] && source "$ZDOTDIR/functions.zsh"

# system dependet
[ -f "/usr/share/fzf/completion.zsh" ] && source "/usr/share/fzf/completion.zsh"
[ -f "/usr/share/fzf/key-bindings.zsh" ] && source "/usr/share/fzf/key-bindings.zsh"

# local customizations: overwriting global
[ -f "$HOME/.aliases" ] && source "$HOME/.aliases"
[ -f "$HOME/.functions" ] && source "$HOME/.functions"

#------------------------------
# Window title
#------------------------------


case $TERM in
    termite|*xterm*|rxvt|rxvt-unicode|rxvt-256color|rxvt-unicode-256color|(dt|k|E)term)
    precmd () {
      vcs_info
      print -Pn "\e]0;zsh [%~]\a"
    }
    preexec () { print -Pn "\e]0;zsh [%~] ($1)\a" }
    ;;
  screen|screen-256color)
    precmd () {
      vcs_info
      print -Pn "\e]83;title \"$1\"\a"
      print -Pn "\e]0;$TERM - (%L) [zsh]%# [%~]\a"
    }
    preexec () {
      print -Pn "\e]83;title \"$1\"\a"
      # print -Pn "\e]0;$TERM - (%L) [%n@%M]%# [%~] ($1)\a"
      print -Pn "\e]0;$TERM - (%L) [zsh]%# [%~] ($1)\a"
    }
    ;;
esac

if !  command -v hostname > /dev/null 2>&1 && [ -f /proc/sys/kernel/hostname ]; then
    hostname() { cat /proc/sys/kernel/hostname ; }
fi

# emacs libvterm
function vterm_printf() {
    if [ -n "$TMUX" ]; then
        # Tell tmux to pass the escape sequences through
        # (Source: http://permalink.gmane.org/gmane.comp.terminal-emulators.tmux.user/1324)
        printf "\ePtmux;\e\e]%s\007\e\\" "$1"
    elif [ "${TERM%%-*}" = "screen" ]; then
        # GNU screen (screen, screen-256color, screen-256color-bce)
        printf "\eP\e]%s\007\e\\" "$1"
    else
        printf "\e]%s\e\\" "$1"
    fi
}

vterm_prompt_end() {
    vterm_printf "51;A$(whoami)@$(hostname):$(pwd)";
}

setopt PROMPT_SUBST
PROMPT=$PROMPT'%{$(vterm_prompt_end)%}'

export TERM='xterm-256color'

### DIR COLORS ####
alias ls='ls --color=auto'
LS_COLORS="no=0;38;15:rs=0:di=1;34:ln=01;35:mh=00:pi=40;33:so=1;38;211:do=01;35:bd=40;33;01:cd=40;33;01:or=40;31;01:su=37;41:sg=30;43:ca=30;41:tw=30;42:ow=30;42:st=37;44:ex=1;30;32:*.tar=01;31:*.tgz=01;31:*.arj=01;31:*.taz=01;31:*.lzh=01;31:*.lzma=01;31:*.tlz=01;31:*.txz=01;31:*.zip=01;31:*.z=01;31:*.Z=01;31:*.dz=01;31:*.gz=01;31:*.lz=01;31:*.xz=01;31:*.bz2=01;31:*.bz=01;31:*.tbz=01;31:*.tbz2=01;31:*.tz=01;31:*.deb=01;31:*.rpm=01;31:*.jar=01;31:*.war=01;31:*.ear=01;31:*.sar=01;31:*.rar=01;31:*.ace=01;31:*.zoo=01;31:*.cpio=01;31:*.7z=01;31:*.rz=01;31:*.jpg=01;35:*.jpeg=01;35:*.gif=01;35:*.bmp=01;35:*.pbm=01;35:*.pgm=01;35:*.ppm=01;35:*.tga=01;35:*.xbm=01;35:*.xpm=01;35:*.tif=01;35:*.tiff=01;35:*.png=01;35:*.svg=01;35:*.svgz=01;35:*.mng=01;35:*.pcx=01;35:*.mov=01;35:*.mpg=01;35:*.mpeg=01;35:*.m2v=01;35:*.mkv=01;35:*.webm=01;35:*.ogm=01;35:*.mp4=01;35:*.m4v=01;35:*.mp4v=01;35:*.vob=01;35:*.qt=01;35:*.nuv=01;35:*.wmv=01;35:*.asf=01;35:*.rm=01;35:*.rmvb=01;35:*.flc=01;35:*.avi=01;35:*.fli=01;35:*.flv=01;35:*.gl=01;35:*.dl=01;35:*.xcf=01;35:*.xwd=01;35:*.yuv=01;35:*.cgm=01;35:*.emf=01;35:*.axv=01;35:*.anx=01;35:*.ogv=01;35:*.ogx=01;35:*.aac=01;33:*.au=01;33:*.flac=01;33:*.mid=01;33:*.midi=01;33:*.mka=01;33:*.mp3=01;33:*.mpc=01;33:*.ogg=01;33:*.ra=01;33:*.wav=01;33:*.axa=01;33:*.oga=01;33:*.spx=01;33:*.xspf=01;33:*.doc=01;91:*.ppt=01;91:*.xls=01;91:*.docx=01;91:*.pptx=01;91:*.xlsx=01;91:*.odt=01;91:*.ods=01;91:*.odp=01;91:*.pdf=01;91:*.tex=01;91:*.md=01;91:"

export LS_COLORS
export GPG_TTY=$(tty)

