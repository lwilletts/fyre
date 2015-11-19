#!/bin/mksh
#
# wildefyr - 2015 (c) wtfpl
# checks a windows class

usage() {
    printf '%s\n' "usage: $(basename $0) <command> <wid>" >&2
    exit 1
}

case $1 in
    c|class)
        xprop -id $2 WM_CLASS | cut -f 2 -d \"
        ;;
    m|more)
        xprop -id $2 WM_CLASS | cut -f 4 -d \"
        ;;
    ca|classAll)
        for i in $(seq $(lsw | wc -l)); do
            echo $(lsw | head -n $i  | tail -1) $(wclass.sh c $(lsw | head -n $i | tail -1)) 
        done
        ;;
    ma|moreAll)
        for i in $(seq $(lsw | wc -l)); do
            echo $(lsw | head -n $i  | tail -1) $(wclass.sh m $(lsw | head -n $i | tail -1)) 
        done
        ;;
    name)
        for i in $(seq $(lsw | wc -l)); do
            echo $(lsw | head -n $i  | tail -1) $(wname $(lsw | head -n $i | tail -1)) 
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
