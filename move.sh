#!/bin/sh
#
# wildefyr - 2016 (c) wtfpl
# move a window its width/height / snap it to edge of the screen  

readonly PROGNAME=$(basename $0)
readonly PROGDIR=$(readlink -m $(dirname $0))
readonly PROGPATH=${PROGPATH:-$PROGDIR/$PROGNAME}
ARGS="$@"

usage() {
    printf '%s\n' "Usage: $PROGNAME <direction>"
    test -z $1 && exit 0 || exit $1
}

move_left() {
    X=$(wattr x $PFW)
    Y=$(wattr y $PFW)
    X=$((X - minW - IGAP - BW))
    test $X -le $XGAP && \
        snap.sh h && exit
}

move_down() {
    X=$(wattr x $PFW)
    Y=$(wattr y $PFW)
    Y=$((Y + minH + IGAP + BW))
    test $((Y + H)) -gt $SH && \
        snap.sh j && exit
}

move_up() {
    X=$(wattr x $PFW)
    Y=$(wattr y $PFW)
    Y=$((Y - minH - IGAP - BW))
    test $Y -lt $TGAP && \
        snap.sh k && exit
}

move_right() {
    X=$(wattr x $PFW)
    Y=$(wattr y $PFW)
    X=$((X + minW + IGAP + BW))
    test $((X + W)) -gt $SW && \
        snap.sh l && exit
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
        *)       usage      ;;
    esac

    wtp $X $Y $W $H $PFW
}

main $ARGS
