#!/bin/sh
#
# wildefyr - 2015 (c) wtfpl
# move windows into all sorts of useful positions

. ~/.config/fyre/fyrerc

case $2 in
    0x*)
        PFW=$2
        ;;
esac

case $1 in
    tl)
        Y=$TGAP
        ;;
    tll)
        X=$((X - 1))
        Y=$TGAP
        ;;
    tr)
        X=$((SW - W - XGAP - BW*2))
        Y=$TGAP
        ;;
    bl)
        Y=$((SH - H - BGAP))
        ;;
    br)
        X=$((SW - W - XGAP - BW*2))
        Y=$((SH - H - BGAP))
        ;;
    md)
        X=$((SW/2 - W/2 - BW))
        Y=$((SH/2 - H/2 - BW))
        ;;
    mid)
        SW=$((SW - 2*XGAP))
        SH=$((SH - TGAP - BGAP))
        W=$((SW/2 - 2*BW))
        H=$((SH/2 - BW))
        SW=$(wattr w $ROOT)
        SH=$(wattr h $ROOT)
        X=$((SW/2 - W/2 - BW))
        Y=$((SH/2 - H/2 - BW))
        ;;
    lft)
        Y=$TGAP
        SW=$((SW - 2*XGAP))
        SH=$((SH - TGAP - BGAP))
        W=$((SW/2 - 2*BW))
        H=$SH
        ;;
    rht)
        Y=$TGAP
        H=$((SH - TGAP - BGAP))
        SW=$((SW - 2*XGAP))
        W=$(((SW - 2*IGAP - 2*BW)/2))
        X=$((W + XGAP + IGAP + BW))
        ;;
    full)
        SW=$((SW - 2*XGAP - 2*BW))
        SH=$((SH - TGAP - BGAP))
        Y=$TGAP
        W=$SW; H=$SH
        ;;
    ext)
        X=$(wattr x $PFW)
        Y=$TGAP
        H=$((SH - TGAP - BGAP))
        ;;
    res)
        SW=$((SW - 2*XGAP))
        SH=$((SH - TGAP - BGAP))
        W=$((SW/4 - BW))
        H=$((SH/4 - BW))
        X=$(wattr x $PFW); Y=$(wattr y $PFW)
        ;;
    vid)
        X=$(wattr x $PFW); Y=$(wattr y $PFW)
        W=$(resolution.sh $PFW | cut -d\  -f 1)
        H=$(resolution.sh $PFW | cut -d\  -f 2)
        ;;
    *)
        cat $0
        ;;
esac

wtp $X $Y $W $H $PFW
