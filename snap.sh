#!/bin/sh
#
# wildefyr & kekler - 2016 (c) wtfpl
# snap windows without resize

ARGS="$@"

usage() {
    cat << EOF
Usage: $(basename $0) <option> [wid]
    h  | left:   Snap current or given window to the left side of the screen.
    j  | down:   Snap current or given window to the bottom side of the screen.
    k  | up:     Snap current or given window to the up side of the screen.
    l  | right:  Snap current or given window to the right side of the screen.
    tl | tleft:  Snap current or given window to the top-left corner of the screen.
    tr | tright: Snap current or given window to the top-right corner of the screen.
    bl | bleft:  Snap current or given window to the bottom-left corner of the screen.
    br | bright: Snap current or given window to the bottom-right corner of the screen.
    md | middle: Snap current or given window to the middle of the screen.
    h  | help:   Show this help.
EOF
    test -z $1 && exit 0 || exit $1
}

snap_left() {
    X=$XGAP
}

snap_up() {
    Y=$TGAP
}

snap_down() {
    Y=$((SH - BGAP - H))
}

snap_right() {
    X=$((SW - XGAP - W - BW))
}

snap_tl() {
    X=$XGAP
    Y=$TGAP
}

snap_tr() {
    X=$((SW - XGAP - W - BW))
    Y=$TGAP
}

snap_bl() {
    X=$XGAP
    Y=$((SH - BGAP - H))
}

snap_br() {
    X=$((SW - XGAP - W - BW)) 
    Y=$((SH - BGAP - H))
}

snap_md() {
    SW=$((SW - 2*XGAP))
    SH=$((SH - TGAP - BGAP))
    X=$((SW/2 - W/2 + XGAP - 1)) 
    Y=$((SH/2 - H/2 + TGAP + 1))
}

moveMouse() {
    . mouse.sh

    mouseStatus=$(getMouseStatus)
    test "$mouseStatus" -eq 1 && moveMouseEnabled $PFW
}

main() {
    . fyrerc.sh

    case $2 in
        0x*) PFW=$2 ;;
    esac

    case $1 in 
        h|left)    snap_left  ;;
        j|down)    snap_down  ;;
        k|up)      snap_up    ;;
        l|right)   snap_right ;;
        tl|tleft)  snap_tl    ;;
        tr|tright) snap_tr    ;;
        bl|bleft)  snap_bl    ;;
        br|bright) snap_br    ;;
        md|middle) snap_md    ;;
        *)         usage      ;;
    esac

    wtp $X $Y $W $H $PFW
    moveMouse
} 

main $ARGS
