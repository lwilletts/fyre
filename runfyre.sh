#!/bin/sh
#
# wildefyr - 2016 (c) wtfpl
# checks currently visible windows

. fyrerc.sh

test ! -z $1 && DURATION=$1

while :; do

    test -f $MPVPOS && rm $MPVPOS

    for wid in $(lsw); do
        windowClass=$(class $wid)

        test "$windowClass" = "mpv" && {
            printf '%s ' $(wattr xywh $wid) > $MPVPOS
        }

    done

    sleep $DURATION
done
