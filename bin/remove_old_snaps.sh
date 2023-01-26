#!/bin/bash

sudo apt-get autoremove
sudo apt-get autoclean
rm -rf ~/.local/share/Trash/*
docker system prune

# Removes old revisions of snaps
# CLOSE ALL SNAPS BEFORE RUNNING THIS
set -eu

LANG=en_US.UTF-8 snap list --all | awk '/disabled/{print $1, $3}' |
    while read snapname revision; do
        snap remove "$snapname" --revision="$revision"
    done
