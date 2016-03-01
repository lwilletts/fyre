#!/bin/sh
#
# wildefyr - 2016 (c) wtfpl
# move AND resize windows to useful positions

ARGS="$@"

usage() {
    cat << EOF
Usage: $(basename $0) <option> [wid]
    res:  Restore the current or given window to minW and minH values.
    ext:  Extend the current or given window to the max SH value.
    quar: Make the current or given window a quarter of the screen.
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
    H=$((SH - TGAP - BGAP))
}

quarter() {
    SW=$((SW - 2*XGAP))
    SH=$((SH - TGAP - BGAP))
    W=$((SW/2 - BW))
    H=$((SH/2 - BW + 1))
}

left() {
    X=$XGAP
    Y=$TGAP
    SW=$((SW - 2*XGAP))
    SH=$((SH - TGAP - BGAP))
    W=$((SW/2 - IGAP/2 - BW))
    H=$SH
}

right() {
    Y=$TGAP
    H=$((SH - TGAP - BGAP))
    SW=$((SW - 2*XGAP))
    W=$(((SW - IGAP - 2*BW)/2))
    X=$((W + XGAP + IGAP + BW))
}

full() {
    SW=$((SW - 2*XGAP - BW))
    SH=$((SH - TGAP - BGAP))
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
    test "$mouseStatus" -eq 1 && moveMouseEnabled $PFW
}

main() {
    . fyrerc.sh

    case $2 in
        0x*) PFW=$2 ;;
    esac

    case $1 in
        res)  restore ;;
        ext)  extend  ;;
        quar) quarter ;;
        lft)  left    ;;
        rht)  right   ;;
        full) full    ;;
        vid)  video   ;;
        *)    usage 0 ;;
    esac

    wtp $X $Y $W $H $PFW
    moveMouse
}

main $ARGS
