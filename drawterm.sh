#!/bin/sh
#
# wildefyr - 2016 (c) wtfpl
# use slop to get xywh position for urxvt window

ARGS="$@"

main() {
    . fyrerc.sh

    eval $(slop -t 0 -b $BW '215,215,215,0.9')

    test ! -z "$1" && {
        urxvt -e sh -c "$@" &
    } || {
        urxvt -name 'slop' &
    }

    sleep 0.01
    slopWid=$(wid.sh "slop" | tail -1)

    test ! -z $slopWid && {
        wtp $X $Y $W $H $slopWid
    } || {
        printf '%s\n' "URxvt window was not found." >&2
    }
}

main $ARGS
