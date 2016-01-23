#!/bin/sh
#
# wildefyr - 2016 (c) wtfpl
# test window classes when being opened

ARGS="$@"

usage() {
    cat << EOF
Usage: $(basename $0) <wid>
EOF

    test -z $1 && exit 0 || exit $1
}

main() {
    . fyrerc.sh

    case $1 in
        0x*) wid=$1 ;;
        *)   usage  ;;
    esac

    . wclass.sh
    windowName=$(name $wid)
    windowClass=$(class $wid)

    # for speed
    setborder.sh active $wid

    # put the things you open the most often at the top
    test "$windowName" = "urxvt" && {
        position.sh res $wid
        snap.sh tl $wid
        exit
    }

    test "$windowName" = "mosh" && {
        position.sh quar $wid
        snap.sh md $wid
        wgroups.sh -s $wid 3
        exit
    }

    test "$windowName" = "tmux" && {
        position.sh res $wid
        snap.sh tl $wid
        move.sh right $wid
        exit
    }

    test "$windowName" = "mpsyt" && {
        position.sh res $wid
        position.sh ext $wid
        snap.sh right $wid
        wgroups.sh -s $wid 9
        exit
    }

    test "$windowName" = "alsamixer" && {
        position.sh quar $wid
        snap.sh md $wid
        exit
    }

    test "$windowClass" = "mpv" && {
        wgroups.sh -s $wid 5
        position.sh vid $wid

        test -f $MPVPOS && {
            Wcur=$(wattr w $wid)
            Hcur=$(wattr h $wid)
            W=$(cat $MPVPOS | cut -d\  -f 3)
            H=$(cat $MPVPOS | cut -d\  -f 4)
            test $W -gt $Wcur && $H -gt $Hcur && {
                wtp $(cat $MPVPOS) $wid
            } || {
                wtp $(cat $MPVPOS | cut -d\  -f -2) $Wcur $Hcur $wid
            }
        }
        exit
    }

    test "$windowClass" = "google-chrome" && {
        wgroups.sh -s $wid 1
        exit
    }

    test "$windowClass" = "TeamSpeak 3" && {
        position.sh res $wid
        position.sh ext $wid
        snap.sh left $wid
        wgroups.sh -s $wid 4
        exit
    }

    test "$windowClass" = "MuPDF" && {
        wgroups.sh -s $wid 6
        exit
    }

    test "$windowName" = "winecfg.exe" && {
        snap.sh md $wid
        exit
    }

    snap.sh md $wid
}

main $ARGS
