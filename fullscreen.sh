#!/bin/sh
#
# wildefyr & z3bra - 2016 (c) wtfpl
# fullscreen without borders, remembers previous window geometry

ARGS="$@"

usage() { 
    printf '%s\n' "Usage: $(basename $0) [wid]"
    test -z $1 || exit $1
}

main() {
    . fyrerc.sh

    case $1 in
        0x*) wid=$1  ;;
        *)   usage 0 ;;
    esac

    test -e "$FSFILE" && { 
        test "$PFW" = "$wid" && {
            setborder.sh active $wid
            wtp $(cat $FSFILE)
            rm $FSFILE
        }
        test "$PFW" != "$wid" && {
            setborder.sh active $wid
            setborder.sh inactive $PFW
            wtp $(cat $FSFILE)
            rm $FSFILE
            $(basename $0) $wid
        }
        exit
    }

    setborder.sh none $wid
    wattr xywhi $wid > $FSFILE
    wtp 0 0 $SW $SH $wid
}

main $ARGS
