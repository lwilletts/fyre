#!/bin/sh
#
# wildefyr & kekler - 2015 (c) wtfpl
# snap windows without resize

. ~/.config/fyre/fyrerc

usage() {
    printf '%s\n' "usage: $(basename $0) <direction/position> (wid)"
    exit 1
}

case $2 in
    0x*) PFW=$2 ;;
esac

snap_left() {
    wtp $XGAP $Y $W $H $PFW
}

snap_down() {
    wtp $X $((SH - BGAP - H)) $W $H $PFW
}

snap_up() {
    wtp $XGAP $TGAP $W $H $PFW
}

snap_right() {
    wtp $((SW - XGAP - W - 2*BW)) $Y $W $H $PFW
}

snap_tl() {
    wtp $XGAP $TGAP $W $H $PFW
}

snap_tr() {
    wtp $((SW - XGAP - W - 2*BW)) $TGAP $W $H $PFW
}

snap_bl() {
    wtp $XGAP $((SH - BGAP - H)) $W $H $PFW
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
