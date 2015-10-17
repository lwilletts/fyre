#!/bin/mksh
#
# z3bra - 2014 (c) wtfpl
# Fullscreen without borders. Remembers previous window geometry

source fyrerc.sh

usage() {
    echo "Usage: $(basename $0) <wid>"
    exit 1
}

test -z "$1" && test -z "$2" && usage

test -f $FSFILE && wtp $(cat $FSFILE)

if test -f $FSFILE && grep -q $1 $FSFILE; then
    rm -f $FSFILE
elif [[ $(cat $FSFILE | cut -d' ' -f 5) != $1 ]]; then
    wattr xywhi $1 > $FSFILE
    wtp 0 0 $SW $SH $1
    setborder.sh none $1
else
    wattr xywhi $1 > $FSFILE
    wtp 0 0 $SW $SH $1
    setborder.sh none $1
fi

vroum.sh $1
