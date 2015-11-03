#!/bin/sh
#
# wildefyr - 2015 (c) wtfpl
# toggle delete lock to current window

usage() {
    printf '%s\n' "usage: $(basename $0) <lock|unlock|toggle|status> <wid>"
}

wid=$(pfw)

case $2 in
    0x*)
        wid=$2
        ;;
esac

case $1 in
    lock)
        xprop -id $wid -f _WMUTILS_DELETELOCK 8i -set _WMUTILS_DELETELOCK '1'
        ;;
    unlock)
        xprop -id $wid -remove _WMUTILS_DELETELOCK
        ;;
    toggle)
        lockStatus=$(xprop -id $wid _WMUTILS_DELETELOCK | grep -q '1'; echo $?)
        case $lockStatus in
            0)
                $(basename $0) unlock $wid 
                ;;
            *)
                $(basename $0) lock $wid 
                ;;
        esac
        ;;
    status)
        lockStatus=$(xprop -id $wid _WMUTILS_DELETELOCK | grep -q '1'; echo $?)
        case $lockStatus in
            0)
                printf '%s\n' "1"
                ;;
            *)
                printf '%s\n' "0"
                ;;
        esac
        ;;
    *)
        usage
        ;;
esac
