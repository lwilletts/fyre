#!/bin/sh
#
# File       : /home/wildefyr/fyre/move
# Maintainer : Wildefyr | http://wildefyr.net
# Copyright  : Wildefyr | Licensed under the WTFPL license.

source fyrerc

case $1 in
    h|left)
        X=$(wattr x $PFW)
        X=$((X - W - IGAP - 2*BW))
        if [ $X -lt 0 ]; then
            X=$(wattr x $PFW)
        fi
        ;;
    j|down)
        X=$(wattr x $PFW)
        Y=$(wattr y $PFW)
        Y=$((Y + H + IGAP + 2*BW))
        ;;
    k|up)
        X=$(wattr x $PFW)
        Y=$(wattr y $PFW)
        Y=$((Y - H - IGAP - 2*BW))
        if [ $Y -lt 0 ]; then
            Y=$(wattr y $PFW)
        fi
        ;;
    l|right)
        X=$(wattr x $PFW)
        X=$((X + W + IGAP + BW))
        if [ $X -gt $SW ]; then
            X=$(wattr x $PFW)
        fi
        ;;
esac

wtp $X $Y $W $H $CUR
tile
