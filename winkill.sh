#!/bin/mksh
#
# wildefyr - 2015 (c) wtfpl
# Performs checks and tasks when window has been targetted for termination

wid=$1
windowC=$(wclass.sh c $wid)
windowP=$(wclass.sh p $wid)

if [[ $(wclass c $(pfw)) == "urxvtc" ]]; then
    exit
fi

killw $(pfw)
