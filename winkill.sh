#!/bin/sh
#
# wildefyr - 2016 (c) wtfpl
# i was happy with killwa before telegram showed up in my life

usage() {
    cat << EOF
Usage: $(basename $0) [wid]
EOF

    test $# -eq 0 || exit $1
}

case $1 in
    0x*) wid=$1  ;;
    *)   usage 1 ;;
esac

. fyrerc.sh

windowClass=$(class $wid)

case "$windowClass" in
    "telegram")
        printf '%s\n' "You're terminated fucker."
        killw $wid
        ;;
    *)
        killwa $wid
        ;;
esac
