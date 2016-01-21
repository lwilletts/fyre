#!/bin/sh
#
# wildefyr - 2016 (c) wtfpl
# find resoluton of mpv video based on window id

ARGS="$@"

usage() {
    printf '%s\n' "Usage: $(basename $0) <mpvwid>"
    test -z $1 && exit 0 || exit $1
}

resolution() {
    case $1 in
        0x*) wid=$1 ;;
        *)   usage  ;;
    esac

    . wclass.sh
   
    test "$(class $wid)" = "mpv" && {
        mpvWid=$(xprop -id "$wid" WM_NORMAL_HINTS | sed '5s/[^0-9]*//p;d' | tr / \ )
        printf '%s\n' "$mpvWid"
    } || {
        printf '%s\n' "Please enter a valid mpv window id." >&2
    }
}

main() {
    resolution $1
}

test -z "$ARGS" || main $ARGS
