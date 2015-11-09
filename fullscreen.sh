#!/bin/mksh
#
# wildefyr & z3bra - 2015 (c) wtfpl
# fullscreen without borders, remembers previous window geometry

source ~/.config/fyre/fyrerc

usage() { 
    echo "usage: $(basename $0) <wid>"
    exit 1
}

if [ ! -z $1 ]; then
    case $1 in
        0x*)
            PFW=$1
            ;;
    esac
fi

windowC=$(wclass.sh c $PFW)

if [[ -e $FSFILE ]] && [[ $(cat $FSFILE | cut -d\  -f 5) == $PFW ]]; then
    wtp $(cat $FSFILE)
fi

if [[ -e $FSFILE ]] && [[ $(cat $FSFILE | cut -d\  -f 5) != $PFW ]]; then
    wtp $(cat $FSFILE)
    rm $FSFILE
    fullscreen.sh $PFW
elif [[ -e $FSFILE ]] && [[ $(cat $FSFILE | cut -d\  -f 5) == $PFW ]]; then
    rm $FSFILE
else
    wattr xywhi $PFW > $FSFILE
    wtp 0 0 $SW $SH $PFW
fi
