#!/bin/sh
#
# wildefyr - 2016 (c) wtfpl
# performs checks when window has been targetted for termination

ARGS="$@"

usage() {
    printf '%s\n' "Usage: $(basename $0) <wid>"
    test -z $1 && exit 0 || exit $1
}

main() {
    wid=$(pfw)

    . wclass.sh
    windowName=$(name $wid)
    windowClass=$(class $wid)

    test "$windowName" = "urxvtc" && {
        killwa $wid
        exit 0
    }

    test "$windowName" = "Navigator" && {
        killwa $wid
        exit 0
    }

    test "$windowName" = "Steam" && {
        killwa $wid
        exit 0
    }

    test "$windowClass" = "Teamspeak 3" && {
        killwa $wid
        exit 0
    }

    printf '%s\n' "you're terminated fucker."
    killw $wid
}

main $ARGS
