#!/bin/mksh
#
# wildefyr - 2015 (c) wtfpl
# move windows into all sorts of useful positions

source ~/.config/fyre/fyrerc

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
        Y=$TGAP
        X=$((X - 1))
        ;;
    tr)
        Y=$TGAP
        X=$((SW - W - XGAP - BW*2))
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
        W=$((2*TermW)); H=$((2*TermH))
        X=$((SW/2 - W/2 - BW))
        Y=$((SH/2 - H/2 - BW))
        if [ $X -eq $(wattr x $PFW) ]; then
            exit
        fi
        ;;
    full)
        Y=$TGAP
        SW=$((SW - 2*XGAP - 2*BW))
        SH=$((SH - TGAP - BGAP - BW))
        W=$SW; H=$SH
        ;;
    lft)
        Y=$TGAP
        X=$((X))
        SW=$((SW - 2*XGAP - BW))
        W=$((SW/2 - IGAP/2 - BW))
        H=$((SH - TGAP - BGAP - BW))
        ;;
    rht)
        Y=$TGAP
        SW=$((SW - 2*XGAP))
        X=$((W + XGAP + IGAP - BW))
        H=$((SH - TGAP - BGAP - BW))
        W=$((SW/2 - IGAP/2 - 2*BW - 1))
        ;;
    ext)
        Y=$TGAP
        W=$TermW
        X=$(wattr x $PFW)
        H=$((SH - TGAP - BGAP - BW))
        ;;
    res)
        W=$TermW; H=$TermH
        X=$(wattr x $PFW); Y=$(wattr y $PFW)
        ;;
    *)
        cat $0
        ;;
esac

wtp $X $Y $W $H $PFW
