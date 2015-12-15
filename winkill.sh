#!/bin/sh
#
# wildefyr - 2015 (c) wtfpl
# performs checks when window has been targetted for termination

wid=$(pfw)
windowC=$(wclass.sh c $wid)

if [ "$windowC" = "urxvtc" ]; then
    killwa $wid
elif [ "$windowC" = "Navigator" ]; then
    killwa $wid
else
    printf '%s\n' "you're terminated fucker."
    killw $wid
fi

