#!/bin/mksh
#
# wildefyr - 2015 (c) wtfpl
# checks a windows class

source fyrerc.sh

usage() {
    printf '%s\n' "usage: $(basename $0) <class|classAll|process|processAll> <wid>" >&2
    exit 1
}

case $1 in
    c|class)
        xprop -id $2 WM_CLASS | cut -f 2 -d \"
        ;;
    p|process)
        ps -o command $(xprop -id $2 _NET_WM_PID | awk '{print $NF}') | sed '1d'
        ;;
    ca|classAll)
        for i in $(seq $(lsw | wc -l)); do
            wclass.sh c $(lsw | head -n $i | tail -1)
        done
        ;;
    pa|processAll)
        for i in $(seq $(lsw | wc -l)); do
            wclass.sh p $(lsw | head -n $i | tail -1)
        done
        ;;
    m)
        xprop -id $2 WM_CLASS | cut -f 4 -d \"
        ;;
    *)
        usage
        ;;
esac
