#!/bin/sh
#
# wildefyr & z3bra - 2015 (c) wtfpl
# fullscreen without borders, remembers previous window geometry

. ~/.config/fyre/fyrerc

usage() { 
    echo "usage: $(basename $0) <wid>"
    exit 1
}

case $1 in 
    0x*) wid=$1 ;;
    *) usage ;;
esac

windowC=$(wclass.sh c $wid)

if [ -e $FSFILE ] && [ $(cat $FSFILE | cut -d\  -f 5) = $wid ]; then
    setborder.sh active $wid
    wtp $(cat $FSFILE)
    rm $FSFILE
elif [ -e $FSFILE ] && [ $(cat $FSFILE | cut -d\  -f 5) != $wid ]; then
    setborder.sh active $wid
    wtp $(cat $FSFILE)
    rm $FSFILE
    fullscreen.sh $CUR
else
    setborder.sh none $wid
    wattr xywhi $wid > $FSFILE
    wtp 0 0 $SW $SH $wid
fi

tile.sh
