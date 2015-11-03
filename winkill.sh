#!/bin/mksh
#
# wildefyr - 2015 (c) wtfpl
# performs checks when window has been targetted for termination

wid=$(pfw)
windowM=$(wclass.sh m $wid)

if [ $(deletelock.sh status $wid) -eq 1 ]; then
    exit
fi

if [[ $windowM == "Firefox" ]]; then
    killwa $wid
fi

printf '%s\n' "you're terminated fucker."
killw $wid
