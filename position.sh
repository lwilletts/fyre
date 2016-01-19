#!/bin/sh
#
# wildefyr - 2016 (c) wtfpl
# move AND resize windows to useful positions

ARGS="$@"

usage() {
    printf '%s\n' "Usage: $(basename $0) <mid|lft|rht|full|ext|vid> [wid]"
    test -z $1 && exit 0 || exit $1
}

restore() {
    SW=$((SW - 2*XGAP))
    SH=$((SH - TGAP - BGAP))
    W=$((SW/4 - 2*BW))
    H=$((SH/4 - BW - 1))
    if [ $W -lt $minW ] || [ $H -lt $minH ]; then
        W=$minW
        H=$minH
    fi
}

extend() {
    Y=$TGAP
    H=$((SH - TGAP - BGAP + BW))
}

middle() {
    SW=$((SW - 2*XGAP))
    SH=$((SH - TGAP - BGAP))
    W=$((SW/2 - BW))
    H=$((SH/2 - BW))
}

left() {
    X=$XGAP
    Y=$TGAP
    SW=$((SW - 2*XGAP))
    SH=$((SH - TGAP - BGAP + BW))
    W=$((SW/2 - BW))
    H=$SH
}

right() {
    Y=$TGAP
    H=$((SH - TGAP - BGAP + BW))
    SW=$((SW - 2*XGAP))
    W=$(((SW - 2*IGAP - 2*BW)/2))
    X=$((W + XGAP + IGAP + BW))
}

full() {
    SW=$((SW - 2*XGAP - BW))
    SH=$((SH - TGAP - BGAP + BW))
    X=$XGAP; Y=$TGAP
    W=$SW; H=$SH
}

video() {
    W=$(resolution.sh $PFW | cut -d\  -f 1)
    H=$(resolution.sh $PFW | cut -d\  -f 2)
}

main() {
    . fyrerc.sh

    case $2 in
        0x*) PFW=$2 ;;
    esac

    case $1 in
        res)  restore ;;
        ext)  extend  ;;
        mid)  middle  ;;
        lft)  left    ;;
        rht)  right   ;;
        full) full    ;;
        vid)  video   ;;
        *)    usage   ;;
    esac
    
    wtp $X $Y $W $H $PFW
}

main $ARGS
