#!/bin/sh

# Local config
[[ -f ~/.local/.xinitrc ]] && source ~/.local/.xinitrc

# Start Awesome DM
exec awesome
