#!/bin/sh
#
# wildefyr - 2016 (c) wtfpl
# sane resizing in a direction

ARGS="$@"

usage() {
    printf '%s\n' "Usage: $(basename $0) <gd|gr|sl|su> [wid]"
    test -z $1 && exit 0 || exit $1
}

grow_down() {
    test $H -lt $minH && \
        H=$minH || \
        H=$((H + minH + VGAP + BW))
    wtp $X $Y $W $H $PFW
}

shrink_up() {
    test $H -le $minH && \
        H=$((H/2 - BW)) || \
        H=$((H - minH - VGAP - BW))
    wtp $X $Y $W $H $PFW
}

grow_right() {
    test $W -lt $minW  && \
        W=$minW || \
        W=$((W + minW + IGAP + BW))
    # test $W -gt $SH && \
    #     W=
    wtp $X $Y $W $H $PFW
}

shrink_left() {
    test $W -le $minW && \
        W=$((W/2 - BW)) || \
        W=$((W - minW - IGAP - BW))
    wtp $X $Y $W $H $PFW
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
        gd|growdown)    grow_down    ;;
        su|shrinkup)    shrink_up    ;;
        gr|growright)   grow_right   ;;
        sl|shrinkleft)  shrink_left  ;;
        h|help)         usage        ;;
        *)              usage        ;;
    esac
}

main $ARGS
