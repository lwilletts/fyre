#!/bin/sh
#
# wildefyr - 2015 (c) wtfpl
# make the current window 'flicker' - inspired by rainbow.sh
# this doesn't work too well on transparent windows that overlap

FREQ=${FREQ:-0.1}
VALUES="0.75 0.76 0.77 0.78 0.79 0.80 0.81 0.82 0.83 0.84 0.85 0.86 0.87 0.88 0.89 0.9 0.89 0.88 0.87 0.86 0.85 0.84 0.83 0.82 0.81 0.80 0.79 0.78 0.77 0.76 0.75"

TRANS=$(echo $VALUES | cut -d\  -f 1)

while :; do
    for c in $VALUES; do
        wid=$(pfw)

        if [ "$CUR" != "$wid" ]; then
            if [ "$(wclass.sh m $CUR)" = "URxvt" ]; then
                transset-df -i $CUR $TRANS > /dev/null
            fi

            if [ "$(wclass.sh m $wid)" = "URxvt" ]; then
                transset-df -i $wid $TRANS > /dev/null
            fi
 
            CUR=$wid
            break
        fi

        if [ "$(wclass.sh m $wid)" = "URxvt" ]; then
            transset-df -i $wid $c > /dev/null
        fi

        sleep $FREQ
        CUR=$wid
    done
done
