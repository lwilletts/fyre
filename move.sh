#!/bin/sh
#
# wildefyr - 2016 (c) wtfpl
# move a window its width/height / snap it to edge of the screen  

ARGS="$@"

usage() {
    printf '%s\n' "Usage: $(basename $0) <direction>"
    test -z $1 && exit 0 || exit $1
}

move_left() {
    X=$(wattr x $PFW)
    Y=$(wattr y $PFW)
    X=$((X - minW - IGAP - BW))
    test $X -le $XGAP && \
        snap.sh h && exit

    wtp $X $Y $W $H $PFW
}

move_down() {
    X=$(wattr x $PFW)
    Y=$(wattr y $PFW)
    Y=$((Y + minH + IGAP + BW))
    test $((Y + H)) -gt $SH && \
        snap.sh j && exit

    wtp $X $Y $W $H $PFW
}

move_up() {
    X=$(wattr x $PFW)
    Y=$(wattr y $PFW)
    Y=$((Y - minH - IGAP - BW))
    test $Y -lt $TGAP && \
        snap.sh k && exit

    wtp $X $Y $W $H $PFW
}

move_right() {
    X=$(wattr x $PFW)
    Y=$(wattr y $PFW)
    X=$((X + minW + IGAP + BW))
    test $((X + W)) -gt $SW && \
        snap.sh l && exit

    wtp $X $Y $W $H $PFW
}

main() {
    . fyrerc.sh

    # calculate usable screen size (root minus border gaps)
    SW=$((SW - 2*XGAP))
    SH=$((SH - TGAP - BGAP))

    case $1 in
        h|left)  move_left  ;;
        j|down)  move_down  ;;
        k|up)    move_up    ;;
        l|right) move_right ;;
        h|help)  usage      ;;
        *)       usage      ;;
    esac
}

main $ARGS
