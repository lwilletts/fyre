#!/bin/sh
#
# wildefyr - 2016 (c) wtfpl
# sane resize in a direction

ARGS="$@"

usage() {
    cat << EOF
Usage: $(basename $0) <direction> [wid]
    gr | growright:  Grow current or given window right
    gd | growdown:   Grow current or given window down.
    sl | shrinkleft: Shrink current or given window left.
    su | shrinkup:   Shrink current or given window up.
    h  | help:       Show this help.
EOF

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
        *)              usage        ;;
    esac
}

main $ARGS
