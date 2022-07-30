#!/bin/zsh

# Path
PATH=$HOME/.dotfiles/bin:$PATH
PATH=$HOME/.cargo/bin:$PATH

# Include local configuration
[[ -f ~/.local/.zprofile ]] && source ~/.local/.zprofile

# Apply changes to keyboard key mapping
xmodmap ~/.Xmodmap
