#!/bin/sh
#
# wildefyr & kekler - 2015 (c) wtfpl
# snap windows to borders - fyre compatible

. ~/.config/fyre/fyrerc

usage() {
    printf '%s\n' "usage: $(basename $0) <direction>"
    exit 1
}

snap_left() {
    wtp $X $(wattr y $PFW) $W $H $PFW
}

snap_down() {
    wtp $(wattr x $PFW) $((SH - BGAP - H)) $W $H $PFW
}

snap_up() {
    wtp $(wattr x $PFW) $TGAP $W $H $PFW
}

snap_right() {
    wtp $((SW - XGAP - W - 2*BW)) $(wattr y $PFW) $W $H $PFW
}

case $1 in 
    h|left)  snap_left ;;
    j|down)  snap_down ;;
    k|up)    snap_up ;;
    l|right) snap_right ;;
    *)       usage ;;
esac
