#!/bin/sh
#
# wildefyr - 2015 (c) wtfpl
# mimic i3 tiled windows swapping positions

. ~/.config/fyre/fyrerc

usage() {
    printf '%s\n' "usage: $(basename $0) <direction>"
    exit 1
}

case $1 in
    h|left)
        X=$(wattr x $PFW)
        Y=$(wattr y $PFW)
        X=$((X - W - IGAP - BW))
        if [ $X -lt 0 ]; then
            snap.sh left
            exit 0
        fi
        ;;
    j|down)
        X=$(wattr x $PFW)
        Y=$(wattr y $PFW)
        Y=$((Y + H + IGAP + BW))
        if [ $((Y + H)) -gt $SH ]; then
            snap.sh down
            exit 0
        fi
        ;;
    k|up)
        X=$(wattr x $PFW)
        Y=$(wattr y $PFW)
        Y=$((Y - H - IGAP - BW))
        if [ $Y -lt 0 ]; then
            snap.sh up
            exit 0
        fi
        ;;
    l|right)
        X=$(wattr x $PFW)
        Y=$(wattr y $PFW)
        X=$((X + W + IGAP + BW))
        if [ $((X + W)) -gt $SW ]; then
            snap.sh right
            exit 0
        fi
        ;;
    *) usage ;;
esac

wtp $X $Y $W $H $PFW
