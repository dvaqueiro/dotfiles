#!/bin/bash

active=1
currentPath=$( dirname -- "$0"; )

if [ "$active" == 1 ]; then
    sed -i 's/size: 20.0/size: 14.0/' $currentPath/../conf/.config/alacritty/alacritty.yml
    sed -i 's/^active=1/active=0/' $currentPath/presentation_mode.sh
else
    sed -i 's/size: 14.0/size: 20.0/' $currentPath/../conf/.config/alacritty/alacritty.yml
    sed -i 's/^active=0/active=1/' $currentPath/presentation_mode.sh
fi
