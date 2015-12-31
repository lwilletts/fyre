#!/bin/sh
#
# wildefyr - 2015 (c) wtfpl
# find resoluton of mpv video based on window id

usage() {
    printf '%s\n' "usage: $(basename $0) <wid>"
    exit 1
}

test -z $1 && usage

wid=$1

if [ $(wclass.sh c $wid) = "mpv" ]; then
    printf '%s\n' "$(xprop -id $wid WM_NORMAL_HINTS | sed '5s/[^0-9]*//p;d' | tr / \ )"
else
    printf '%s\n' "error: not a mpv wid"
    exit 2
fi
