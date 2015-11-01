#!/bin/mksh
#
# wildefyr - 2015 (c) wtfpl
# script to put windows into a *nix photo generic order /INCOMPLETE/

ignore() {
    if [ -e $DETECT ]; then
        cat $DETECT > $WLFILETEMP
    fi
    lsw >> $WLFILETEMP
}

prettytile() {
    sort $WLFILETEMP | uniq -u | xargs wattr xi | sort -n | \
    awk '{print $2}' > $WLFILE

    SW=$((SW - 2*XGAP - BW))
    SH=$((SH - TGAP - BGAP - BW))

    COLS=2
    W=$(((SW - (COLS - 1)*IGAP)/COLS))
    H=$SH

    COLSTEMP=$((COLS - 1))
    cat $WLFILE | head -n $COLSTEMP > $WLFILETEMP

    for c in $(seq $COLSTEMP); do
        wtp $X $Y $W $H $(head -n $c $WLFILETEMP | tail -1)
        X=$((X + W + IGAP - BW))
    done

    cat $WLFILE | tail -n $((windowsOnscreen - COLSTEMP)) > $WLFILETEMP

    ROWS=$(cat $WLFILETEMP | wc -l)
    H=$(((SH - (ROWS - 1)*VGAP)/ROWS))
    if [ $COLS -eq 3 ]; then
        W=$((W + maxHorizontalWindows - 1))
    fi

    for c in $(seq $ROWS); do
        if [ $c -ne 1 ]; then
            if [ $((c % 2)) -eq 1 ]; then
                H=$((H + 1))
            fi
        fi
        wtp $X $Y $W $H $(head -n $c $WLFILETEMP | tail -1)
        Y=$((Y + H + VGAP))
    done
}

main() {
    source ~/.config/fyre/fyrerc
    source detection.sh

    # Calculate usable screen size (without borders and gaps)
    SW=$((SW - 2*XGAP - BW))
    SH=$((SH - TGAP - BGAP - BW))

    ignore

    if [ $windowsOnscreen -le 4 ]; then
        prettytile
    fi

    if [ -e $WLFILETEMP ]; then
        rm $WLFILETEMP
    fi
}

main
