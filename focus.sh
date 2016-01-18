#!/bin/sh
#
# wildefyr & z3bra - 2015 (c) wtfpl
# focus wrapper with fullscreen checks

. ~/.config/fyre/fyrerc

usage() {
    echo "usage: $(basename $0) <next|prev|full|wid>"
    exit 1
}

case $1 in
    next) wid=$(lsw | grep -v $CUR | sed '1 p;d') ;;
    prev) wid=$(lsw | grep -v $CUR | sed '$ p;d') ;;
    full) if [ -e $FSFILE ]; then wid=$(cat $FSFILE | cut -d\  -f 5); else usage; fi ;;
    0x*) wattr $1 && wid=$1 ;;
    *) usage ;;
esac

chwso -r $wid
wtf $wid

# focus correctly even if there is a fullscreen window
if [ -e $FSFILE ]; then
    if [ $(cat $FSFILE | cut -d\  -f 5) = $wid ]; then
        setborder.sh none $wid
    elif [ $(cat $FSFILE | cut -d\  -f 5) = $CUR ]; then
        setborder.sh active $wid
        setborder.sh none $CUR
    else
        if [ $wid != $CUR ]; then
            setborder.sh active $wid
            setborder.sh inactive $CUR
        fi
    fi
else
    if [ $wid != $CUR ]; then
        setborder.sh active $wid
        setborder.sh inactive $CUR
    fi
fi

X=$(wattr x $wid)
Y=$(wattr w $wid)
W=$(wattr y $wid)
H=$(wattr h $wid)

# move mouse to the middle of the window
wmp -a $(wattr xy $wid)
wmp -r $(($(wattr w $wid) / 2)) $(($(wattr h $wid) / 2))
