#!/bin/sh
#
# wildefyr - 2016 (c) MIT
# move a window its width/height / snap it to edge of the screen

usage() {
    cat >&2 << EOF
Usage: $(basename $0) <direction> [wid]
    h | left:  Move current or given window its width or minW left.
    j | down:  Move current or given window its height or minH down.
    k | up:    Move current or given window its height or minH up.
    l | right: Move current or given window its width or minW right.
    h | help:  Show this help.
EOF

    test $# -eq 0 || exit $1
}

move_left() {
    X=$(wattr x $PFW)
    Y=$(wattr y $PFW)
    test $W -gt $minW && {
        X=$((X - minW - IGAP - BW))
    } || {
        X=$((X - minW - IGAP))
    }
    test $X -le $XGAP && {
        snap.sh h
        exit
    }
}

move_right() {
    X=$(wattr x $PFW)
    Y=$(wattr y $PFW)
    test $W -gt $minW && {
        X=$((X + minW + IGAP + BW))
    } || {
        X=$((X + minW + IGAP))
    }
    test $((X + W)) -gt $SW && {
        snap.sh l
        exit
    }
}

move_down() {
    test $H -gt $minH && {
        Y=$((Y + minH + VGAP + BW))
    } || {
        Y=$((Y + minH + VGAP))
    }
    test $((Y + H)) -gt $SH && {
        snap.sh j
        exit
    }
}

move_up() {
    X=$(wattr x $PFW)
    Y=$(wattr y $PFW)
    test $H -gt $minH && {
        Y=$((Y - minH - VGAP - BW))
    } || {
        Y=$((Y - minH - VGAP))
    }
    test $Y -lt $TGAP && {
        snap.sh k
        exit
    }
}

moveMouse() {
    . mouse.sh

    mouseStatus=$(getMouseStatus)
    test "$mouseStatus" -eq 1 && moveMouseEnabled $wid
}

. fyrerc.sh

wid=$PFW

case $2 in
    0x*) wid=$2 ;;
esac

SW=$eSW
SH=$eSH

case $1 in
    h|left)  move_left  ;;
    j|down)  move_down  ;;
    k|up)    move_up    ;;
    l|right) move_right ;;
    *)       usage 0    ;;
esac

wtp $X $Y $W $H $wid
test "$MOUSE" = "true" && moveMouse
