#!/bin/sh
#
# wildefyr - 2016 (c) wtfpl
# test window classes when being opened

ARGS="$@"

usage() {
    printf '%s\n' "Usage: $PROGNAME <wid>"
    test -z $1 && exit 0 || exit $1
}

main() {
    . fyrerc.sh

    test -z $1 && usage 1

    wid=$1

    . wclass.sh
    windowName=$(name $wid)
    windowClass=$(class $wid)

    # for speed
    setborder.sh active $wid

    if [ "$windowName" = "Dialog" ]; then
        snap.sh md $wid
    elif [ "$windowName" = "mosh" ]; then
        position.sh mid $wid
        snap.sh md $wid
        wgroups.sh -s $wid 3
    elif [ "$windowClass" = "TeamSpeak 3" ]; then
        position.sh res $wid
        position.sh ext $wid
        snap.sh left $wid
        wgroups.sh -s $wid 4
    elif [ "$windowClass" = "mpv" ]; then
        wgroups.sh -s $wid 5
        position.sh vid $wid

        test -f $MPVPOS && \
            Wcur=$(wattr w $wid)
            Hcur=$(wattr h $wid)
            W=$(cat $MPVPOS | cut -d\  -f 3)
            H=$(cat $MPVPOS | cut -d\  -f 4)
            test $W -gt $Wcur && $H -gt $Hcur && \
                wtp $(cat $MPVPOS) $wid || \
                wtp $(cat $MPVPOS | cut -d\  -f -2) $Wcur $Hcur $wid

    elif [ "$windowName" = "mupdf" ]; then
        wgroups.sh -s $wid 6
    elif [ "$windowName" = "mpsyt" ]; then
        position.sh res $wid
        position.sh ext $wid
        snap.sh right $wid
        wgroups.sh -s $wid 9
    elif [ "$windowName" = "alsamixer" ]; then
        position.sh res $wid
        snap.sh md $wid
    elif [ "$windowClass" = "URxvt" ]; then
        position.sh res $wid
        snap.sh tl $wid
    else
        snap.sh md $wid
    fi
}

main $ARGS
