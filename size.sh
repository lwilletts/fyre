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
    wtp $X $Y $W $((H*2 + VGAP + BW)) $PFW
}

grow_right() {
    wtp $X $Y $((W*2 + IGAP + BW)) $H $PFW
}

shrink_left() {
    wtp $X $Y $((W/2 - BW)) $H $PFW
}

shrink_up() {
    wtp $X $Y $W $((H/2 - BW)) $PFW
}

case $1 in 
    gd|growdown)    grow_down    ;;
    su|shrinkup)    shrink_up    ;;
    gr|growright)   grow_right   ;;
    sl|shrinkleft)  shrink_left  ;;
esac
