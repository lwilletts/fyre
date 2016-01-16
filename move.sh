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
        X=$((X - minW - IGAP - BW))
        test $X -le $XGAP && \
            snap.sh left; exit
        ;;

    j|down)
        X=$(wattr x $PFW)
        Y=$(wattr y $PFW)
        Y=$((Y + minH + IGAP + BW))
        test $((Y + H)) -gt $SH && \
            snap.sh down; exit
        ;;

    k|up)
        X=$(wattr x $PFW)
        Y=$(wattr y $PFW)
        Y=$((Y - minH - IGAP - BW))
        test $Y -lt $TGAP && \
            snap.sh up; exit
        ;;

    l|right)
        X=$(wattr x $PFW)
        Y=$(wattr y $PFW)
        X=$((X + minW + IGAP + BW))
        test $((X + W)) -gt $SW && \
            snap.sh right; exit
        ;;

    *) usage ;;
     
esac

wtp $X $Y $W $H $PFW
