#!/usr/bin/env bash

# exec-once=awww-daemon in hyprland conf

# activates
#  - some hyprland keybind

# Control how smoothly the transition will happen and/or it's frame rate
# For the step, smaller values = more smooth. Default = 20
# For the frame rate, default is 30.
awww img {path/to/timage} \
--transition-step {1-255} \
--transistion-fps {1-255} \
--transition-type center \
