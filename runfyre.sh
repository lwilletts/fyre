#!/bin/sh
#
# wildefyr - 2016 (c) wtfpl
# checks currently visible windows

. ~/.config/fyre/fyrerc

DURATION=20
test ! -z $1 && DURATION=$1

while :; do

    for wid in $(lsw); do
        windowC=$(wclass.sh c $wid)

        if [ $windowC = "mpv" ]; then
            printf '%s ' $(wattr xywh $wid) > $MPVPOS
        elif [ $windowC = "mpv" ] && [ ! -f $MPVPOS ]; then
            rm $MPVPOS
        fi

    done

    sleep $DURATION
done
