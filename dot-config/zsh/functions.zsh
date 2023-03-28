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

function hack_running() {
    # podman container ls -a --format "{{.Names}}" --filter status=running | grep -q kali
    lxc list -c n "status=running" | grep -q kali
}

function hack() {
    if ! hack_running; then
        #podman container start kali
        lxc start kali
    fi
    lxc exec kali -- su -l
}

alias hack_stop='lxc stop kali'

function netlab_running() {
    # podman container ls -a --format "{{.Names}}" --filter status=running | grep -q kali
    lxc list -c n "status=running" | grep -q netlab
}

function netlab() {
    if ! netlab_running; then
        #podman container start kali
        lxc start netlab
    fi
    lxc exec netlab -- su -l
}

alias netlab_stop='lxc stop netlab'

function mbed_running() {
    # podman container ls -a --format "{{.Names}}" --filter status=running | grep -q kali
    lxc list -c n "status=running" | grep -q mbed
}

function mbed() {
    if ! mbed_running; then
        #podman container start kali
        lxc start mbed
    fi
    lxc exec mbed -- su -l baker
}

alias mbed_stop='lxc stop mbed'
