#!/bin/zsh

# Path
PATH=$HOME/.dotfiles/bin:$PATH

# Include local configuration
[[ -f ~/.local/.zprofile ]] && source ~/.local/.zprofile

