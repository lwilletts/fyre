#!/bin/sh
#
# wildefyr - 2016 (c) wtfpl
# test window classes when being opened

ARGS="$@"

usage() {
    cat << EOF
Usage: $(basename $0) <wid>
EOF

    test -z $1 || exit $1
}

main() {
    . fyrerc.sh

    case $1 in
        0x*) wid=$1  ;;
        *)   usage 0 ;;
    esac

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

    test "$windowClass" = "google-chrome" && {
        wtp $(($(wattr x $wid) - BW)) $(($(wattr y $wid) - BW)) $(wattr wh $wid) $wid
        wgroups.sh -s $wid 2
        exit
    }

    test "$windowName" = "mosh" && {
        position.sh res $wid
        position.sh ext $wid
        snap.sh tl $wid
        wgroups.sh -s $wid 3
        exit
    }

    test "$windowName" = "tmux" && {
        position.sh res $wid
        position.sh ext $wid
        snap.sh tl $wid
        wgroups.sh -s $wid 1
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
        exit
    }

    test "$windowClass" = "TeamSpeak 3" && {
        snap.sh md $wid
        wgroups.sh -s $wid 4
        exit
    }

    test "$windowClass" = "MuPDF" && {
        wgroups.sh -s $wid 6
        exit
    }

    test "$windowName" = "Legions.exe" && {
        wgroups.sh -s $wid 6
        exit
    }

    snap.sh md $wid
}

main $ARGS
