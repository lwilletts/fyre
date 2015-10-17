#!/bin/sh
#
# wildefyr - 2015 (c) wtfpl
# Arrange windows in a *nix photogeneric way

source fyrerc.sh

ignore() {
    cat $DETECT > $WLFILETEMP
    lsw >> $WLFILETEMP
}

prettyTile() {
    ignore

    sort $WLFILETEMP | uniq -u | xargs wattr xi | sort -n | \
    awk '{print $2}' > $WLFILE

    SW=$((SW / 2))
    SH=$((SH / 2 + 200))
    echo $SW $SH

    for c in $(seq $COLS); do
        if [ $c -eq 3 ]; then X=$((X + 1)); fi
        wtp $X $Y $W $H $(head -n $c $WLFILE | tail -1)
        X=$((X + W + IGAP))
    done

}

main() {
    if [ ! -z $mpvWid ]; then
        exit
    else
        detection.sh
        pretty.sh
    fi
}

main
