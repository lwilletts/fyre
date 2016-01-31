#!/bin/sh
#
# wildefyr & z3bra - 2014 (c) wtfpl
# find and focus the closest window in a specific direction

ARGS="$@"

usage() {
    printf '%s\n' "Usage: $(basename $0) <direction>"
    test -z $1 || exit $1
}

next_east() {
    lsw | xargs wattr xi | sort -nr | sed "0,/$PFW/d" | sed "1s/^[0-9]* //p;d"
}

# WIDLIST=${WIDLIST:-~/.config/fyre/widlist}
# SRTLIST=${SRTLIST:-~/.config/fyre/srtlist}

# pfw=$(pfw | xargs wattr xi) 
# pfwVal=$(echo $pfw | cut -d\  -f 1)
# pfwID=$(echo $pfw | cut -d\  -f 2)

# printf '%s\n' $pfwID > $SRTLIST

# lsw | xargs wattr xi | sort -n | grep -v "$pfw" > $WIDLIST

# for i in $(seq $(cat $WIDLIST | wc -l)); do
#     cur=$(cat $WIDLIST | head -n $i | tail -1)
#     curVal=$(echo $cur | cut -d\  -f 1)
#     curID=$(echo $cur | cut -d\  -f 2)
#     test $pfwVal -eq $curVal && printf '%s\n' $curID >> $SRTLIST
# done

test "$(cat $SRTLIST | wc -l)" -gt 1 && {
    cat $SRTLIST | xargs wattr yi | sort -n | sed "0,/$PFW/d" | sed "1s/^[0-9]* //p;d"
} || {
    lsw | xargs wattr xi | sort -nr | sed "0,/$PFW/d" | sed "1s/^[0-9]* //p;d"
}

next_west() {
    lsw | xargs wattr xi | sort -n | sed "0,/$PFW/d" | sed "1s/^[0-9]* //p;d"
}

next_north() {
    lsw | xargs wattr yi | sort -nr | sed "0,/$PFW/d" | sed "1s/^[0-9]* //p;d"
}

next_south() {
    lsw | xargs wattr yi | sort -n | sed "0,/$PFW/d" | sed "1s/^[0-9]* //p;d"
}

main() {
    . fyrerc.sh

    case $1 in
        h|east|left)  focus.sh $(next_east)  2>/dev/null ;;
        j|south|down) focus.sh $(next_south) 2>/dev/null ;;
        k|north|up)   focus.sh $(next_north) 2>/dev/null ;;
        l|west|right) focus.sh $(next_west)  2>/dev/null ;;
        *)            usage 0                            ;;
    esac
}

main $ARGS
