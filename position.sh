#!/bin/sh
#
# wildefyr - 2016 (c) MIT
# move AND resize windows to useful positions

usage() {
    cat >&2 << EOF
Usage: $(basename $0) <option> [wid]
    res:  Restore the current or given window to minW and minH values.
    ext:  Extend the current or given window to the max SH value.
    lft:  Make the current or given window half of the screen positioned on the left.
    rht:  Make the current or given window half of the screen positioned on the right.
    full: Make the current or given window fullscreen minus border gaps.
    vid:  Make the current or given mpv window its currently playing video's resolution.
    help: Show this help.
EOF

    test $# -eq 0 || exit $1
}

restore() {
    W=$minW
    H=$minH
}

extend() {
    Y=$TGAP
    H=$((ROWS*minH + $((ROWS - 1))*VGAP))
}

left() {
    X=$XGAP
    Y=$TGAP
    W=$((2*minW + IGAP))
    H=$((ROWS*minH + $((ROWS - 1))*VGAP))
}

right() {
    Y=$TGAP
    W=$((2*minW + IGAP))
    H=$((ROWS*minH + $((ROWS - 1))*VGAP))
    X=$((W + XGAP + IGAP))
}

full() {
    SW=$eSW
    SH=$eSH
    X=$XGAP; Y=$TGAP
    W=$SW; H=$SH
}

video() {
    W=$(resolution $PFW | cut -d\  -f 1)
    H=$(resolution $PFW | cut -d\  -f 2)
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

case $1 in
    res)  restore ;;
    ext)  extend  ;;
    lft)  left    ;;
    rht)  right   ;;
    full) full    ;;
    vid)  video   ;;
    *)    usage 0 ;;
esac

wtp $X $Y $W $H $wid
test "$MOUSE" = "true" && moveMouse
