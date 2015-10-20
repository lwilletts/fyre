#!/bin/mksh
#
# wildefyr & z3bra - 2015 (c) wtfpl
# fullscreen without borders, remembers previous window geometry

source fyrerc.sh


usage() { 
    echo "usage: $(basename $0) <wid>"
    exit 1
}

if [ -z $1 ]; then
    case $1 in
        0x*)
            PFW=$1
            ;;
    esac
fi

windowC=$(wclass.sh c $PFW)

if [[ -e $FSFILE ]] && [[ $(cat $FSFILE | cut -d\  -f 5) == $PFW ]]; then
    if [[ $windowC == "urxvt" ]] || [[ $windowC == "Terminal" ]]; then
        transset-df -i $PFW 0.75
    fi
    setborder.sh active $PFW
    wtp $(cat $FSFILE)
fi

if [ -f $FSFILE ] && grep -q $PFW $FSFILE; then
    rm $FSFILE
else
    setborder.sh none $PFW
    transset-df -i $PFW 1
    wattr xywhi $PFW > $FSFILE
    wtp 0 0 $SW $SH $PFW
fi

tile.sh
