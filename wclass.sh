#!/bin/sh
#
# wildefyr - 2015 (c) wtfpl
# checks a windows class

usage() {
    printf '%s\n' "usage: $(basename $0) <command> <wid>" >&2
    exit 1
}

case $2 in
    u|-u|unlisted) hidden="-u" ;;
esac

case $1 in
    c|class)
        xprop -id $2 WM_CLASS | cut -f 2 -d \"
        ;;
    m|more)
        xprop -id $2 WM_CLASS | cut -f 4 -d \"
        ;;
    ca|classAll)
        for i in $(seq $(lsw $hidden | wc -l)); do
            wid=$(lsw $hidden | head -n $i | tail -1)
            printf '%s\n' "$wid $(wclass.sh c $wid)"
        done
        ;;
    ma|moreAll)
        for i in $(seq $(lsw $hidden | wc -l)); do
            wid=$(lsw $hidden | head -n $i | tail -1)
            printf '%s\n' "$wid $(wclass.sh m $wid)"
        done
        ;;
    name)
        for i in $(seq $(lsw $hidden | wc -l)); do
            wid=$(lsw $hidden | head -n $i | tail -1)
            printf '%s\n' "$wid $(wname $wid)"
        done
        ;;
    all)
        $(basename $0) ca
        $(basename $0) ma
        $(basename $0) name
        ;;
    *)
        usage
        ;;
esac
