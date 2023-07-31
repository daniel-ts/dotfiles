function fzf-open-in-emacs() {
    fzf-file-widget | xargs -0 emacsclient --create-frame
    zle reset-prompt
}

function insp() {
    echo $1 | sed 's/:/\n/g'
}

function hrec() {
    if [[ $1 =~ "\.scm$" ]]; then
        guix home reconfigure "$HOME/guix/homes/$1"
    else
        guix home reconfigure "$HOME/guix/homes/$1.scm"
    fi
}

function ec() {
    emacsclient --create-frame $@ & disown
}

function lxc-jack-in-running() {
    # --columns 'n' for name of container
    test -z "${1}" && return 1
    lxc list --format=csv --columns 'n' 'status=running' | grep --quiet "${1}"
}

function lxc-jack-in() {
    if test -z "${1}"; then
        echo "no lxd instance given" 1>&2
        exit 1
    fi

    local INST="${1}"
    shift
    if ! lxc-jack-in-running "${INST}"; then
        lxc start "${INST}"
    fi

    lxc exec "${INST}" -- ${@}
}

alias admproj='lxc-jack-in admproj su -l'
alias mbed='lxc-jack-in mbed su -l baker'
alias kali='lxc-jack-in kali su -l'
