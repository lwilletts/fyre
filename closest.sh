#!/bin/sh
#
# z3bra - 2014 (c) wtfpl
# find and focus the closest window in a specific direction

. ~/.config/fyre/fyrerc

usage() {
    printf '%s\n' "usage: $(basename $0) <direction>"
    exit 1
}

CURX=$(wattr x $(pfw))
CURY=$(wattr y $(pfw))


next_east() {
    lsw | xargs wattr xi | sort -nr | sed "0,/$CUR/d" | grep -v $CURX | sed "1s/^[0-9]* //p;d"
}

next_west() {
    lsw | xargs wattr xi | sort -n | sed "0,/$CUR/d" | grep -v $CURX | sed "1s/^[0-9]* //p;d"
}

next_north() {
    lsw | xargs wattr yi | sort -nr | sed "0,/$CUR/d" | grep -v $CURY | sed "1s/^[0-9]* //p;d"
}

next_south() {
    lsw | xargs wattr yi | sort -n | sed "0,/$CUR/d" | grep -v $CURY | sed "1s/^[0-9]* //p;d"
}

case $1 in
    h|east|left)  focus.sh $(next_east)  2>/dev/null ;;
    j|south|down) focus.sh $(next_south) 2>/dev/null ;;
    k|north|up)   focus.sh $(next_north) 2>/dev/null ;;
    l|west|right) focus.sh $(next_west)  2>/dev/null ;;
    *) usage ;;
esac
