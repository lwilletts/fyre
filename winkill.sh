#!/bin/dash
#
# wildefyr - 2015 (c) wtfpl
# performs checks when window has been targetted for termination

wid=$(pfw)
windowC=$(wclass.sh c $wid)
windowM=$(wclass.sh m $wid)

if [ "$windowC" = "Terminal" ]; then
    killwa $wid
elif [ "$windowM" = "Firefox" ]; then
    killwa $wid
else
    printf '%s\n' "you're terminated fucker."
    killw $wid
fi

