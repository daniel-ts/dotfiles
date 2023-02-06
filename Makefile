.DEFAULT_GOAL := all

dot-config:
	stow dot-config --target ${XDG_CONFIG_HOME}

home-dir:
	stow home --target ${HOME}

remove-dot-config:
	stow -D dot-config --target ${XDG_CONFIG_HOME}

remove-home-dir:
	stow -D home --target ${HOME}

unstow: remove-dot-config remove-dot-home

all: dot-config home

# .PHONY := home
