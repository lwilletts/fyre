#!/bin/sh
#
# wildefyr - 2016 (c) wtfpl
# checks currently visible windows

. ~/.config/fyre/fyrerc

DURATION=20
test ! -z $1 && DURATION=$1

while :; do

    for wid in $(lsw); do
        windowName=$(wclass.sh n $wid)
        windowClass=$(wclass.sh c $wid)

        if [ "$windowName" = "Navigator" ]; then
            wgroups.sh -s $wid 2
        elif [ $windowClass = "mpv" ]; then
            printf '%s ' $(wattr xywh $wid) > $MPVPOS
        fi

    done

    sleep $DURATION
done
