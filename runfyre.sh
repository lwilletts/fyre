#!/bin/sh
#
# wildefyr - 2016 (c) wtfpl
# fyre initialisation and run loop


. fyrerc.sh

eventually.sh &
layouts.sh -o 0
xrandr | grep -w 'connected' | sort > $SCREENS

while :; do
    sleep $DURATION
done
