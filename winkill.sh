#!/bin/sh
#
# wildefyr - 2016 (c) wtfpl
# performs checks when window has been targetted for termination

usage() {
    printf '%s\n' "Usage: $PROGNAME <wid>"
    test -z $1 && exit 0 || exit $1
}

wid=$(pfw)
windowName=$(wclass.sh n $wid)

test "$windowName" = "urxvtc" && {
        killwa $wid
        exit 0
    }
test "$windowName" = "Navigator" && {
        killwa $wid
        exit 0
    }

printf '%s\n' "you're terminated fucker."
killw $wid

