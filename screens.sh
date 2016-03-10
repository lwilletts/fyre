#!/bin/sh
#
# wildefyr - 2016 (c) MIT
# generate screens config for wmutils
# USE XRANDR TO PLACE SCREENS WHERE YOU WANT THEM

. fyrerc.sh

test -f "$SCREENS" && rm -f "$SCREENS"

xrandr | grep -w 'connected' | while read -r connected; do
    X="$(printf '%s\n' $connected | cut -d\  -f 3 | cut -d'+' -f 2)"
    Y="$(printf '%s\n' $connected | cut -d\  -f 3 | cut -d'+' -f 3)"
    W="$(printf '%s\n' $connected | cut -d\  -f 3 | cut -d'x' -f 1)"
    H="$(printf '%s\n' $connected | cut -d\  -f 3 | cut -d'x' -f 2 | cut -d'+' -f 1)"
    SCREEN=$(printf '%s\n' $connected | cut -d\ -f 1)
    printf '%s\n' "$ $X $Y $W $H" >> $SCREENS
done
