#!/bin/sh
#
# wildefyr - 2016 (c) wtfpl
# checks currently visible windows

. fyrerc.sh

test ! -z $1 && DURATION=$1

while :; do

    for wid in $(lsw); do
        windowName=$(wclass.sh n $wid)
        windowClass=$(wclass.sh c $wid)

        test "$windowName" = "Navigator" && \
            wgroups.sh -s $wid 2
        test "$windowClass" = "mpv" && \
            printf '%s ' $(wattr xywh $wid) > $MPVPOS

    done

    sleep $DURATION
done
