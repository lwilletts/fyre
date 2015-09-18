#!/bin/sh
#
# File       : /home/wildefyr/fyre/move
# Maintainer : Wildefyr | http://wildefyr.net
# Copyright  : Wildefyr | Licensed under the WTFPL license.

source fyrerc

case $1 in
    h|left)
        X=$(wattr x $PFW)
        Y=$(wattr y $PFW)
        X=$((X - W - IGAP - BW))
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
        ;;
    l|right)
        X=$(wattr x $PFW)
        Y=$(wattr y $PFW)
        X=$((X + W + IGAP + BW))
        ;;
esac

wtp $X $Y $W $H $PFW
tile
