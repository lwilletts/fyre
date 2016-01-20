#!/bin/sh
#
# wildefyr - 2016 (c) wtfpl
# move a window its width/height / snap it to edge of the screen  

ARGS="$@"

usage() {
    cat << EOF
Usage: $(basename $0) <direction> [wid]
    h|left:  Move current or given window its width or minW left.
    j|down:  Move current or given window its height or minH down.
    k|up:    Move current or given window its height or minH up.
    l|right: Move current or given window its width or minW right.
    h|help:  Show this help.
EOF
    test -z $1 && exit 0 || exit $1
}

move_left() {
    X=$(wattr x $PFW)
    Y=$(wattr y $PFW)
    test $W -ge $minW && \ 
        X=$((X - minW - IGAP - BW))
    test $X -le $XGAP && \
        snap.sh h && exit
}

move_down() {
    X=$(wattr x $PFW)
    Y=$(wattr y $PFW)
    test $Y -ge $minH && \ 
        Y=$((Y + minH + IGAP + BW))
    test $((Y + H)) -gt $SH && \
        snap.sh j && exit
}

move_up() {
    X=$(wattr x $PFW)
    Y=$(wattr y $PFW)
    test $Y -ge $minH && \ 
        Y=$((Y - minH - IGAP - BW))
    test $Y -lt $TGAP && \
        snap.sh k && exit
}

move_right() {
    X=$(wattr x $PFW)
    Y=$(wattr y $PFW)
    test $W -ge $minW && \ 
        X=$((X + minW + IGAP + BW))
    test $((X + W)) -gt $SW && \
        snap.sh l && exit
}

moveMouse() {
    . mouse.sh

    mouseStatus=$(getMouseStatus)
    test "$mouseStatus" -eq 1 && moveMouseEnabled $PFW
}

main() {
    . fyrerc.sh

    # calculate usable screen size (root minus border gaps)
    SW=$((SW - 2*XGAP))
    SH=$((SH - TGAP - BGAP))

    case $2 in
        0x*) PFW=$2 ;;
    esac

    case $1 in
        h|left)  move_left  ;;
        j|down)  move_down  ;;
        k|up)    move_up    ;;
        l|right) move_right ;;
        *)       usage      ;;
    esac

    wtp $X $Y $W $H $PFW
    moveMouse
}

main $ARGS
