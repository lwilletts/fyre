#!/bin/sh
#
# wildefyr - 2015 (c) wtfpl
# find resoluton of mpv video based on window id

usage() {
    printf '%s\n' "usage: $(basename $0) <mpvwid>"
    exit 1
}

if [ -z $1 ]; then
    usage
fi

wid=$1

if [[ $(wclass.sh m $wid) == "mpv" ]]; then
    printf '%s\n' "$(xprop -id $wid WM_NORMAL_HINTS | awk '/maximum/ {print $NF}' | sed 's#/# #')"
else
    usage
fi
