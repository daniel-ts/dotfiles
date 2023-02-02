# file: .zprofile

# source .profile
if [ -f "$HOME/.profile" ]; then
    source $HOME/.profile
fi

if [ -f "$HOME/.bash_functions" ]; then
    source $HOME/.bash_functions
fi

if [ -d "/usr/share/fzf" ]; then
    source "/usr/share/fzf/key-bindings.zsh"
    source "/usr/share/fzf/completion.zsh"
fi
