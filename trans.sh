#!/bin/sh
#
# wildefyr - 2015 (c) wtfpl
# transset-df wrapper for sxhkd

usage() {
    printf '%s\n' "usage: $(basename $0) <wid> <value> (inc|dec by value)"
    test -z $1 && exit 0 || exit $1
}

# test for wid value
case $1 in 
    0x*) wid=$1 ;;
    *) usage ;;
esac

# test for number
case $2 in
    ''|*[0-9]*) opacity=$2 ;;
    *) usage ;;
esac

# test for last argument
case $3 in
    u|inc) transset-df -i $wid --inc $opacity > /dev/null; exit ;;
    d|dec) transset-df -i $wid --dec $opacity > /dev/null; exit ;;
    *) transset-df -i $wid $opacity > /dev/null;;
esac
