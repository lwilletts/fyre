#!/bin/mksh
#
# wildefyr - 2015 (c) wtfpl
# personal tiling script, optimised for vertical terminal usage

usage() {
    printf '%s\n' "usage: $(basename $0) <mpv|rxvt>"
    exit 1
}

oneWindow() {
    position.sh full $(cat $WLFILE)
}

horizontalTile() {
    COLS=$(cat $WLFILE | wc -l)
    W=$(((SW - (COLS - 1)*IGAP)/COLS))
    H=$SH

    for c in $(seq $COLS); do
        wtp $X $Y $W $H $(head -n $c $WLFILE | tail -1)
        X=$((X + W + IGAP - BW))
    done
}

mainTile() {
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

mpvTile() {
    
    if [ $mpvWindowsToTile -eq 1 ]; then

        mpvW=$(resolution.sh $mpvWid | cut -d\  -f 1)
        mpvH=$(resolution.sh $mpvWid | cut -d\  -f 2)
        if [ $mpvH -gt 720 ]; then
            mpvH=720
        fi

        case $mpvH in
            360)
                ;;
            480)
                ;;
            720)
                ;;
        esac
    else
        # Assume to take up a 720p space
        mpvW=1280
        mpvH=720
    fi

}

source ~/.config/fyre/fyrerc
source detection.sh

# calculate usable screen size (root minus border gaps)
SW=$((SW - 2*XGAP - BW))
SH=$((SH - TGAP - BGAP - BW))

if [ -z $1 ]; then
    usage
fi

if [ -e $WLFILE ]; then
    windowsToTile=$(cat $WLFILE | wc -l)
    echo $windowsToTile
else
    printf '%s\n' "no windows found, exiting ..."
    exit
fi

case $1 in
    m|mpv)
        if [ -e $MPVFILE ]; then
            printf '%s\n' "no mpv windows found, defaulting to rxvt ..."
            tile.sh rxvt
        else
            mpvWindowsToTile=$(cat $MPVFILE | wc -l)
            mpvTile
        fi
        ;;
    r|rxvt)
        if [ $windowsToTile -eq 1 ]; then
            oneWindow
        elif [ $windowsToTile -le $maxHorizontalWindows ]; then
            horizontalTile
        else
            mainTile
        fi
        ;;
esac
