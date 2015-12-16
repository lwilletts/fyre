#!/bin/sh
#
# wildefyr - 2015 (c) wtfpl
# performs checks when window has been targetted for termination

wid=$(pfw)
windowName=$(wclass.sh n $wid)

if [ "$windowName" = "urxvtc" ]; then
    killwa $wid
elif [ "$windowName" = "Navigator" ]; then
    killwa $wid
else
    printf '%s\n' "you're terminated fucker."
    killw $wid
fi

