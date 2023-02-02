
function fzf-open-in-emacs() {
    fzf-file-widget | xargs -0 emacsclient --create-frame
    zle reset-prompt
}
