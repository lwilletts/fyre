#!/bin/sh
#
# wildefyr - 2016 (c) wtfpl
# window manager loop

. fyrerc.sh

test ! -z $1 && DURATION=$1

while :; do
    xrandr | grep -w 'connected' | sort > $SCREENS
    sleep $DURATION
done
