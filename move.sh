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
        if [ $((Y + H)) -gt $SH ]; then
            Y=$(wattr Y $PFW)
        fi
        ;;
    k|up)
        X=$(wattr x $PFW)
        Y=$(wattr y $PFW)
        Y=$((Y - H - IGAP - BW))
        if [ $Y -lt 0 ]; then
            Y=$(wattr Y $PFW)
        fi
        ;;
    l|right)
        X=$(wattr x $PFW)
        Y=$(wattr y $PFW)
        X=$((X + W + IGAP + BW))
        if [ $((X + W)) -gt $SW ]; then
            X=$(wattr x $PFW)
        fi
        ;;
esac

wtp $X $Y $W $H $PFW
tile.sh
