#!/bin/sh
#
# wildefyr & z3bra - 2015 (c) wtfpl
# focus wrapper with fullscreen checks

. ~/.config/fyre/fyrerc

usage() {
    echo "usage: $(basename $0) <next|prev|wid>"
    exit 1
}

case $1 in
    next) wid=$(lsw | grep -v $CUR | sed '1 p;d') ;;
    prev) wid=$(lsw | grep -v $CUR | sed '$ p;d') ;;
    0x*) wattr $1 && wid=$1 ;;
    *) usage ;;
esac

# focus correctly even if there is a fullscreen window
if [ -e $FSFILE ]; then
    if [[ $(cat $FSFILE | cut -d\  -f 5) == $wid ]]; then
        setborder.sh none $wid
    elif [[ $(cat $FSFILE | cut -d\  -f 5) == $PFW ]]; then
        setborder.sh active $wid
        setborder.sh none $CUR
    else
        setborder.sh active $wid
        setborder.sh inactive $CUR
    fi
else
    setborder.sh active $wid
    setborder.sh inactive $CUR
fi

wtf $wid
