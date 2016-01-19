#!/bin/sh
#
# wildefyr & kekler - 2016 (c) wtfpl
# snap windows without resize

ARGS="$@"

usage() {
    cat << EOF
Usage: $(basename $0) <option> [wid]
    h|left:  Snap window to the left side of the screen.
    j|down:  Snap window to the bottom side of the screen.
    k|up:    Snap window to the up side of the screen.
    l|right: Snap window to the right side of the screen.
    tl:      Snap window to the top-left corner of the screen.
    tr:      Snap window to the top-right corner of the screen.
    bl:      Snap window to the bottom-left corner of the screen.
    br:      Snap window to the bottom-right corner of the screen.
    md:      Snap window to the middle of the screen.
EOF
    test -z $1 && exit 0 || exit $1
}

snap_left() {
    wtp $XGAP $Y $W $H $PFW
}

snap_down() {
    wtp $X $((SH - BGAP - H + BW)) $W $H $PFW
}

snap_up() {
    wtp $X $TGAP $W $H $PFW
}

snap_right() {
    wtp $((SW - XGAP - W - BW)) $Y $W $H $PFW
}

snap_tl() {
    wtp $XGAP $TGAP $W $H $PFW
}

snap_tr() {
    wtp $((SW - XGAP - W - BW)) $TGAP $W $H $PFW
}

snap_bl() {
    wtp $XGAP $((SH - BGAP - H + BW)) $W $H $PFW
}

snap_br() {
    wtp $((SW - XGAP - W - BW)) $((SH - BGAP - H + BW)) $W $H $PFW
}

snap_md() {
    SW=$((SW - 2*XGAP))
    SH=$((SH - TGAP - BGAP))
    wtp $((SW/2 - W/2 - BW + XGAP)) $((SH/2 - H/2 + TGAP)) $W $H $PFW
}

main() {
    . fyrerc.sh

    case $2 in
        0x*) PFW=$2 ;;
    esac

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
} 

test -z "$ARGS" || main $ARGS
