#!/bin/sh
#
# wildefyr - 2015 (c) wtfpl
# move a window it's width/height / snap it to edge of the screen  

. ~/.config/fyre/fyrerc

usage() {
    printf '%s\n' "usage: $(basename $0) <direction>"
    exit 1
}

# calculate usable screen size (root minus border gaps)
SW=$((SW - 2*XGAP))
SH=$((SH - TGAP - BGAP))

case $1 in
    h|left)
        X=$(wattr x $PFW)
        Y=$(wattr y $PFW)
        X=$((X - W - IGAP - BW))
        if [ $X -le $originalX ]; then
            snap.sh left; exit
        fi
        ;;
    j|down)
        X=$(wattr x $PFW)
        Y=$(wattr y $PFW)
        Y=$((Y + H + IGAP + BW))
        if [ $((H + BGAP)) -gt $SH ]; then
            snap.sh down; exit
        fi
        ;;
    k|up)
        X=$(wattr x $PFW)
        Y=$(wattr y $PFW)
        Y=$((Y - H - IGAP - BW))
        if [ $Y -lt $TGAP ]; then
            snap.sh up; exit
        fi
        ;;
    l|right)
        X=$(wattr x $PFW)
        Y=$(wattr y $PFW)
        X=$((X + W + IGAP + BW))
        if [ $((X + W)) -gt $SW ]; then
            snap.sh right; exit
        fi
        ;;
    *) usage ;;
esac

wtp $X $Y $W $H $PFW
