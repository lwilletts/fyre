#!/bin/sh
#
# wildefyr & z3bra - 2016 (c) wtfpl
# fullscreen without borders, remembers previous window geometry

readonly PROGNAME=$(basename $0)
readonly PROGDIR=$(readlink -m $(dirname $0))
readonly PROGPATH=${PROGPATH:-$PROGDIR/$PROGNAME}
ARGS="$@"

usage() { 
    printf '%s\n' "Usage: $PROGNAME <wid>"
    test -z $1 && exit 0 || exit $1
}

main() {
    . fyrerc.sh

    case $1 in 
        0x*) wid=$1 ;;
        *) usage ;;
    esac

    test -e $FSFILE && CUR=$(cat $FSFILE | cut -d\  -f 5)

    if [ -e $FSFILE ] && [ "$CUR" = $wid ]; then
        setborder.sh active $wid
        wtp $(cat $FSFILE)
        rm $FSFILE
    elif [ -e $FSFILE ] && [ "$CUR" != $wid ]; then
        setborder.sh active $wid
        setborder.sh inactive $CUR
        wtp $(cat $FSFILE)
        rm $FSFILE
        $(basename $0) $wid
    else
        setborder.sh none $wid
        wattr xywhi $wid > $FSFILE
        wtp 0 0 $SW $SH $wid
    fi
}

main $ARGS
