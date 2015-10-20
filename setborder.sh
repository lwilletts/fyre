#!/bin/mksh
#
# wildefyr - 2015 (c) wtfpl
# set or unset a border around a window

source fyrerc.sh

# check if window exists
wattr $2 || return

case $1 in
    active)
        chwb -s $BW -c $ACTIVE $2
        ;;
    inactive)
        chwb -s $BW -c $INACTIVE $2
        ;;
    none)
        chwb -s 0 $2
        ;;
esac
