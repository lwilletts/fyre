#!/bin/sh
#
# wildefyr & kekler - 2016 (c) wtfpl
# snap windows without resize

readonly PROGNAME=$(basename $0)
readonly PROGDIR=$(readlink -m $(dirname $0))
readonly PROGPATH=${PROGPATH:-$PROGDIR/$PROGNAME}
ARGS="$@"

usage() {
    cat << EOF
Usage: $PROGNAME <option> [wid]
    h:  Snap window to the left side of the screen.
    j:  Snap window to the bottom side of the screen.
    k:  Snap window to the up side of the screen.
    l:  Snap window to the right side of the screen.
    tl: Snap window to the top-left corner of the screen.
    tr: Snap window to the top-right corner of the screen.
    bl: Snap window to the bottom-left corner of the screen.
    br: Snap window to the bottom-right corner of the screen.
    md: Snap window to the middle of the screen.
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
        h)  snap_left  ;;
        j)  snap_down  ;;
        k)  snap_up    ;;
        l)  snap_right ;;
        tl) snap_tl    ;;
        tr) snap_tr    ;;
        bl) snap_bl    ;;
        br) snap_br    ;;
        md) snap_md    ;;
        *)  usage      ;;
    esac
} 

main $ARGS
