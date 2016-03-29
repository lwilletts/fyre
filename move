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
    X=$((X - minW - IGAP))
    test $X -le $XGAP && {
        snap h
        exit
    }
}

move_right() {
    X=$((X + minW + IGAP))
    test $((X + W)) -gt $eSW && {
        snap l
        exit
    }
}

move_down() {
    Y=$((Y + minH + VGAP))
    test $((Y + H)) -gt $eSH && {
        snap j
        exit
    }
}

move_up() {
    Y=$((Y - minH - VGAP))
    test $Y -lt $TGAP && {
        snap k
        exit
    }
}

moveMouse() {
    . mouse

    mouseStatus=$(getMouseStatus)
    test "$mouseStatus" -eq 1 && moveMouseEnabled $wid
}

. fyrerc

wid=$PFW

case $2 in
    0x*) wid=$2 ;;
esac

case $1 in
    h|left)  move_left  ;;
    j|down)  move_down  ;;
    k|up)    move_up    ;;
    l|right) move_right ;;
    *)       usage 0    ;;
esac

wtp $X $Y $W $H $wid
test "$MOUSE" = "true" && moveMouse
