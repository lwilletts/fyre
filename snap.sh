#!/bin/sh
#
# wildefyr & kekler - 2015 (c) wtfpl
# snap windows to common positions - fyre compatible

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

snap_tl() {
    wtp $X $TGAP $W $H $PFW
}

snap_tr() {
    wtp $((SW - XGAP - W - 2*BW)) $TGAP $W $H $PFW
}

snap_bl() {
    wtp $X $((SH - BGAP - H)) $W $H $PFW
}

snap_br() {
    wtp $((SW - XGAP - W - 2*BW)) $((SH - BGAP - H)) $W $H $PFW
}

snap_md() {
    wtp $((SW/2 - W/2 - BW)) $((SH/2 - H/2 - BW)) $W $H $PFW
}

case $1 in 
    h|left)  snap_left  ;;
    j|down)  snap_down  ;;
    k|up)    snap_up    ;;
    l|right) snap_right ;;
    tl)      snap_tl    ;;
    tr)      snap_tr    ;;
    bl)      snap_bl    ;;
    br)      snap_br    ;;
    md)      snap_md    ;; 
    *)       usage      ;;
esac
