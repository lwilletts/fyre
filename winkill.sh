#!/bin/mksh
#
# wildefyr - 2015 (c) wtfpl
# performs checks and tasks when window has been targetted for termination

wid=$(pfw)
windowM=$(wclass.sh m $wid)
windowP=$(wclass.sh p $wid)

if [[ $windowM == "Firefox" ]]; then
    killwa $wid
fi

if [[ $windowP == *"urxvtd"* ]]; then
    exit
fi

killw $wid
