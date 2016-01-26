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

    test -z $1 || exit $1
}

grow_down() {
    test $H -lt $((minH - BW)) && {
        H=$minH 
    } || {
        H=$((H + minH + VGAP + BW))
        test $((Y + H)) -gt $SH && {
            H=$((SH + TGAP - Y))
        }
    }
}

grow_right() {
    test $W -lt $((minW - BW))  && {
        W=$minW 
    } || {
        W=$((W + minW + IGAP + BW))
        test $((X + W)) -gt $SW && {
            W=$((SW + XGAP - X - BW))
        }
    }
}

shrink_up() {
    test $H -le $minH && {
        H=$((H/2 - BW + 1)) 
    } || {
        H=$((H - minH - VGAP - 1))
    }
}

shrink_left() {
    test $W -le $minW && {
        W=$((W/2 - BW + 1)) 
    } || {
        W=$((W - minW - IGAP - BW))
    }
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
        gd|growdown)    grow_down    ;;
        su|shrinkup)    shrink_up    ;;
        gr|growright)   grow_right   ;;
        sl|shrinkleft)  shrink_left  ;;
        *)              usage 0      ;;
    esac

    wtp $X $Y $W $H $PFW
    moveMouse
}

main $ARGS
