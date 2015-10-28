#!/bin/mksh
#
# wildefyr - 2015 (c) wtfpl
# move windows into all sorts of useful positions

source fyrerc.sh

case $2 in
    0x*)
        PFW=$2
        ;;
esac

if [ -z $1 ]; then
    case $1 in
        tl)
            # something happened.
            ;;
        tll)
            X=$((X - 1))
            ;;
        tr)
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
            SW=$((SW - 2*XGAP - 2*BW))
            SH=$((SH - TGAP - BGAP - BW))
            W=$SW; H=$SH
            ;;
        lft)
            X=$((X))
            SW=$((SW - 2*XGAP - BW))
            W=$((SW/2 - IGAP/2 - 2*BW))
            H=$((SH - TGAP - BGAP - BW))
            ;;
        rht)
            SW=$((SW - 2*XGAP))
            W=$((SW/2 - IGAP/2 - 2*BW - 1))
            X=$((W + XGAP + IGAP - BW))
            H=$((SH - TGAP - BGAP - BW))
            ;;
        ext)
            X=$(wattr x $PFW)
            W=$TermW
            H=$((SH - TGAP - BGAP - BW))
            ;;
        res)
            X=$(wattr x $PFW); Y=$(wattr y $PFW)
            W=$TermW; H=$TermH
            ;;
        *)
            cat $0
            ;;
    esac
fi

wtp $X $Y $W $H $PFW
