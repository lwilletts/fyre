#!/bin/sh
#
# wildefyr - 2015 (c) wtfpl
# mimic i3 tiled windows swapping positions

. ~/.config/fyre/fyrerc

case $1 in
    h|left)
        X=$(wattr x $PFW)
        Y=$(wattr y $PFW)
        X=$((X - W - IGAP - BW))
        if [ $X -lt 0 ]; then
            X=$(wattr x $PFW)
        fi
        ;;
    j|down)
        X=$(wattr x $PFW)
        Y=$(wattr y $PFW)
        Y=$((Y + H + IGAP + BW))
        ;;
    k|up)
        X=$(wattr x $PFW)
        Y=$(wattr y $PFW)
        Y=$((Y - H - IGAP - BW))
        echo $Y
        if [ $Y -lt 0 ]; then
            Y=$(wattr Y $PFW)
        fi
        ;;
    l|right)
        X=$(wattr x $PFW)
        Y=$(wattr y $PFW)
        X=$((X + W + IGAP + BW))
        if [ $X -gt $SW ]; then
            X=$(wattr x $PFW)
        fi
        ;;
esac

wtp $X $Y $W $H $PFW
tile.sh
