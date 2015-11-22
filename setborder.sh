#!/bin/sh
#
# wildefyr & z3bra - 2015 (c) wtfpl
# set or unset a border around a window

. ~/.config/fyre/fyrerc

usage() { 
    printf '%s\n' "usage: $(basename $0) <state> <wid>"
    exit 1
}

# check arguments
test -z $1 && usage
wattr $2 || exit 1

case $1 in
    active)
        chwb -s $BW -c $ACTIVE $2
        ;;
    inactive)
        chwb -s $BW -c $INACTIVE $2
        ;;
    warning)
        chwb -s $BW -c $WARNING $2
        ;;
    none)
        chwb -s 0 $2
        ;;
    *)
        usage
        ;;
esac
