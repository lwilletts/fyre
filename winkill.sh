#!/bin/mksh
#
# wildefyr - 2015 (c) wtfpl
# performs checks when window has been targetted for termination

wid=$(pfw)
windowC=$(wclass.sh c $wid)
windowM=$(wclass.sh m $wid)

if [[ $windowC == "Terminal" ]]; then
    killwa $wid
fi

if [[ $windowM == "Firefox" ]]; then
    killwa $wid
fi

if [ $(deletelock.sh status $wid) -eq 1 ]; then
    exit
fi

printf '%s\n' "you're terminated fucker."
killw $wid
