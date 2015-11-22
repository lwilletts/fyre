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

if [ $(wclass.sh m $wid) = "mpv" ]; then
    wtp $(wattr xy $wid) $(resolution.sh $wid) $wid
else
    usage
fi
