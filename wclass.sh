#!/bin/sh
#
# wildefyr - 2015 (c) wtfpl
# checks a windows class

usage() {
    printf '%s\n' "usage: $(basename $0) <command> (wid|lswArgs)"
    exit 1
}

case $2 in
    u|-u|unlisted) lswArgs="-u" ;;
    o|-o|override) lswArgs="-o" ;;
    a|-a|all) lswArgs="-a" ;;
esac

case $1 in
    n|name)
        case $2 in
            0x*) xprop -id $2 WM_CLASS | cut -d\" -f 2 ;;
            *) usage ;;
        esac
        ;;
    c|class)
        case $2 in
            0x*) xprop -id $2 WM_CLASS | cut -d\" -f 4 ;;
            *) usage ;;
        esac
        ;;
    p|process)
        case $2 in
            0x*) xprop -id $2 _NET_WM_PID | cut -d\  -f 3 ;;
            *) usage ;;
        esac
        ;;
    na|nameAll)
        for i in $(seq $(lsw $lswArgs | wc -l)); do
            wid=$(lsw $lswArgs | sed "$i!d")
            printf '%s\n' "$wid $($0 n $wid)"
        done
        ;;
    ca|classAll)
        for i in $(seq $(lsw $lswArgs | wc -l)); do
            wid=$(lsw $lswArgs | sed "$i!d")
            printf '%s\n' "$wid $($0 c $wid)"
        done
        ;;
    pa|processAll)
        for i in $(seq $(lsw $lswArgs | wc -l)); do
            wid=$(lsw $lswArgs | sed "$i!d")
            printf '%s\n' "$wid $($0 p $wid)"
        done
        ;;
    a|all)
        $(basename $0) na $lswArgs
        $(basename $0) ca $lswArgs

        # find name
        for i in $(seq $(lsw $lswArgs | wc -l)); do
            wid=$(lsw $lswArgs | sed "$i!d")
            printf '%s\n' "$wid $(wname $wid)"
        done
        ;;
    *)
        usage
        ;;
esac
