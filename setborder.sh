#!/bin/mksh
#
# wildefyr - 2015 (c) wtfpl
# Set a border around a window

source fyrerc.sh

# check if window exists
wattr $2 || return

# Do not modify border of fullscreen windows
test "$(wattr xywh $2)" = "$(wattr xywh $ROOT)" && return

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
