#!/bin/sh
#
# wildefyr & z3bra - 2016 (c) wtfpl
# fullscreen without borders, remembers previous window geometry

usage() {
    cat >&2 << EOF
Usage: $(basename $0) [wid]
EOF

    test "$#" -eq 0 || exit $1
}

. fyrerc.sh

wid=$PFW

case $1 in
    0x*) wid=$1 ;;
esac

test -f "$FSFILE" && {
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
