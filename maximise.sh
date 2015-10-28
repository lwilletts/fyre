#!/bin/sh
#
# wildefyr - 2015 (c) wtfpl
# maximise mpv to the current video's resoluton

usage() {
    printf '%s\n' "usage: $(basename $0) <mpvwid>"
    exit 1
}

if [ -z $1 ]; then
    usage
fi

wid=$1

if [[ $(wclass.sh m $wid) == "mpv" ]]; then
    wtp $(wattr xy $wid) $(xprop -id $wid WM_NORMAL_HINTS | awk '/maximum/ {print $NF}' | sed 's/\//\ /') $wid
else
    usage
fi
