#!/bin/sh
#
# wildefyr - 2016 (c) wtfpl
# set xprop flag to ignore a window

ARGS="$@"

usage() {
    cat << EOF
Usage: $(basename $0) <argument> [wid]
    i|ignore:   Set ignore on current or given window.
    u|unignore: Set unignore on current or given window.
    t|toggle:   Toggle ignore on current or given window.
    s|status:   Retrive status of ignore on current or given window.
    h|help:     Show this help.
EOF

    test -z $1 || exit $1
}

setIgnore() {
    xprop -id $wid -f _FYRE_IGNORE 8i -set _FYRE_IGNORE '1'
}

setUnignore() {
    xprop -id $wid -f _FYRE_IGNORE 8i -set _FYRE_IGNORE '0'
}

toggleIgnore() {
    ignoreStatus=$(xprop -id $wid _FYRE_IGNORE | cut -d\  -f 3)
    case $ignoreStatus in
        1) setUnignore ;;
        *) setIgnore   ;;
    esac
}

testIgnore() {
    ignoreStatus=$(xprop -id $wid _FYRE_IGNORE | cut -d\  -f 3)
    case $ignoreStatus in
        1) echo "1" ;;
        *) echo "0" ;;
    esac
}

main() {
    . fyrerc.sh

    case $2 in
        0x*) PFW=$2 ;;
    esac

    case $1 in
        i|ignore)   setIgnore $PFW    ;;
        u|uningore) setUnignore $PFW  ;;
        t|toggle)   toggleIgnore $PFW ;;
        s|status)   testIgnore $PFW   ;;
        *)          usage 0           ;;
    esac
}

main $ARGS
