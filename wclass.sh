#!/bin/sh
#
# wildefyr - 2015 (c) wtfpl
# checks a windows class

usage() {
    printf '%s\n' "usage: $(basename $0) <command> (wid|unlisted)"
    exit 1
}

case $2 in
    u|-u|unlisted) lswArgs="-u" ;;
    o|-o|override) lswArgs="-o" ;;
    a|-a|all) lswArgs="-a" ;;
esac

case $1 in
    c|class)
        case $2 in
            0x*) xprop -id $2 WM_CLASS | cut -d\" -f 2 ;;
            *) usage ;;
        esac
        ;;
    m|more)
        case $2 in
            0x*) xprop -id $2 WM_CLASS | cut -d\" -f 4 ;;
            *) usage ;;
        esac
        ;;
    ca|classAll)
        for i in $(seq $(lsw $lswArgs | wc -l)); do
            wid=$(lsw $lswArgs | sed "$i!d")
            printf '%s\n' "$wid $(wclass.sh c $wid)"
        done
        ;;
    ma|moreAll)
        for i in $(seq $(lsw $lswArgs | wc -l)); do
            wid=$(lsw $lswArgs | sed "$i!d")
            printf '%s\n' "$wid $(wclass.sh m $wid)"
        done
        ;;
    name)
        for i in $(seq $(lsw $lswArgs | wc -l)); do
            wid=$(lsw $lswArgs | sed "$i!d")
            printf '%s\n' "$wid $(wname $wid)"
        done
        ;;
    a|all)
        $(basename $0) ca $lswArgs
        $(basename $0) ma $lswArgs
        $(basename $0) name $lswArgs
        ;;
    *)
        usage
        ;;
esac
