#!/bin/mksh
#
# wildefyr - 2015 (c) wtfpl
# personal tiling script, optimised for vertical terminal usage

usage() {
    printf '%s\n' "usage: $(basename $0)"
    exit 1
}

ignore() {
    if [ -e $DETECT ]; then
        cat $DETECT > $WLFILETEMP
    fi
    lsw >> $WLFILETEMP
}

oneWindow() {
    sort $WLFILETEMP | uniq -u | xargs wattr xi | sort -n | \
    awk '{print $2}' > $WLFILE

    position.sh full $(cat $WLFILE)
}

horizontalTile() {
    sort $WLFILETEMP | uniq -u | xargs wattr xi | sort -n | \
    awk '{print $2}' > $WLFILE

    COLS=$(cat $WLFILE | wc -l)
    W=$(((SW - (COLS - 1)*IGAP)/COLS))
    H=$SH

    for c in $(seq $COLS); do
        wtp $X $Y $W $H $(head -n $c $WLFILE | tail -1)
        X=$((X + W + IGAP - BW))
    done
}

mainTile() {
    sort $WLFILETEMP | uniq -u | xargs wattr xi | sort -n | \
    awk '{print $2}' > $WLFILE

    COLS=$maxHorizontalWindows
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

# quadrantTile() {
#     printf '%s\n' $mpvWid >> $WLFILETEMP
#     sort $WLFILETEMP | uniq -u | xargs wattr xi | sort -n | \
#     awk '{print $2}' > $WLFILE
#     if [ $windowsOnscreen -le 3 ]; then
#         cat $WLFILE | sed '1q' > $WLFILETEMP
#     else
#         cat $WLFILE | sed '2q' > $WLFILETEMP
#     fi
#     COLS=$(cat $WLFILETEMP | wc -l)
#     W=$(((SW - IGAP)/(COLS*2) - IGAP/COLS + 1))
#     H=$SH
#     for c in $(seq $COLS); do
#         wtp $X $Y $W $H $(head -n $c $WLFILETEMP | tail -1)
#         X=$((X + W + IGAP - BW))
#     done
#     if [ $windowsOnscreen -le 3 ]; then
#         cat $WLFILE | sed '1d' > $WLFILETEMP
#     else
#         cat $WLFILE | sed '1,2d' > $WLFILETEMP
#     fi
#     COLS=$(cat $WLFILETEMP | wc -l)
#     if [ $COLS -eq 1 ]; then EXTRA=$((IGAP)); else EXTRA=0; fi
#     W=$(((SW - IGAP)/(COLS*2) - IGAP/COLS + 1))
#     H=$(((SH - VGAP)/2 - BW*2))
#     for c in $(seq $COLS); do
#         if [ $((ROWS % 2)) -eq 1 ]; then
#             if [ $((c % 2)) -eq 1 ] && [ $c -ne 1 ]; then
#                 X=$((X + 1))
#             fi
#         fi
#         wtp $X $Y $W $H $(head -n $c $WLFILETEMP | tail -1)
#         X=$((X + W + IGAP - BW))
#     done
#     # TODO: Make this scale based on the video's resolution
#     X=$(((SW - IGAP)/2 + IGAP + XGAP - 1))
#     Y=$((Y + H + BW))
#     W=$(((SW - IGAP)/2 - 2*BW + 1))
#     H=$(((SH - VGAP)/2 + 2*BW))
#     wtp $X $Y $W $H $mpvWid
# }

main() {
    source fyrerc.sh
    source detection.sh

    # Calculate usable screen size (without borders and gaps)
    SW=$((SW - 2*XGAP - BW))
    SH=$((SH - TGAP - BGAP - BW))

    ignore

    if [ $windowsOnscreen -eq 0 ]; then
        oneWindow
    elif [ $windowsOnscreen -eq 1 ]; then
        oneWindow
    elif [ $windowsOnscreen -le $maxHorizontalWindows ]; then
        horizontalTile
    else
        mainTile
    fi

    if [ -e $WLFILETEMP ]; then
        rm $WLFILETEMP
    fi
}

main
