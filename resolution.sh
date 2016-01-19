#!/bin/sh
#
# wildefyr - 2016 (c) wtfpl
# find resoluton of mpv video based on window id

ARGS="$@"

usage() {
    printf '%s\n' "Usage: $(basename $0) <mpvwid>"
    test -z $1 && exit 0 || exit $1
}

main () {
    test -z $1 && usage 1

    wid=$1

    if [ "$(wclass.sh c $wid)" = "mpv" ]; then
        printf '%s\n' "$(xprop -id $wid WM_NORMAL_HINTS | \ 
        sed '5s/[^0-9]*//p;d' | tr / \ )" 
    else
        printf '%s\n' "Please enter a valid mpv wid" >&2
        usage 1
    fi
}

test -z "$ARGS" || main $ARGS
