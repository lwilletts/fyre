#!/bin/sh
#
# wildefyr - 2016 (c) MIT
# fyre initialisation and run loop

. fyrerc.sh

eventually.sh &
layouts.sh -o 0
screens.sh

while true; do
    sleep "$DURATION"

    mpvid="$(wid.sh mpv)"
    test ! -z "$mpvid" && {
        printf '%s\n' "$(wattr xywhi ${mpvid})" > "$MPVPOS"
    } || {
        test -f "$MPVPOS" && {
            rm -f "$MPVPOS"
        }
    }
done
