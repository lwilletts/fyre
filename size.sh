#!/bin/sh
#
# wildefyr - 2015 (c) wtfpl
# sane resizing in a direction

. ~/.config/fyre/fyrerc

usage() {
    printf '%s\n' "usage: $(basename $0) <gd|gr|sl|su> (wid)"
    exit 1
}

case $2 in
    0x*) PFW=$2 ;;
esac

grow_down() {
    if [ $H -lt $minH ]; then
        H=$minH
    else
        H=$((H + minH + BW*2))
    fi
    wtp $X $Y $W $H $PFW
}

grow_right() {
    if [ $W -lt $minW ]; then
        W=$minW
    else
        W=$((W + minW + BW*2))
    fi
    wtp $X $Y $W $H $PFW
}

shrink_left() {
    if [ $W -le $minW ]; then
        W=$((W/2 - BW))
    else
        W=$((W - minW - BW*2))
    fi
    wtp $X $Y $W $H $PFW
}

shrink_up() {
    if [ $H -le $minH ]; then
        H=$((H/2 - BW))
    else
        H=$((H - minH - BW*2))
    fi
    wtp $X $Y $W $H $PFW
}

case $1 in 
    gd|growdown)    grow_down    ;;
    su|shrinkup)    shrink_up    ;;
    gr|growright)   grow_right   ;;
    sl|shrinkleft)  shrink_left  ;;
esac
