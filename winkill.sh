#!/bin/mksh
#
# wildefyr - 2015 (c) wtfpl
# performs checks and tasks when window has been targetted for termination

wid=$1
windowP=$(wclass.sh p $wid)

if [[ $windowP == *"urxvtd"* ]]; then
    exit
fi

killw $(pfw)
