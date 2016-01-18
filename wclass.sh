#!/bin/sh
#
# wildefyr - 2016 (c) wtfpl
# returns window xprop environment setting depending on wid

readonly PROGNAME=$(basename $0)
readonly PROGDIR=$(readlink -m $(dirname $0))
readonly PROGPATH=${PROGPATH:-$PROGDIR/$PROGNAME}
ARGS="$@"

usage() {
    cat << EOF
Usage: $PROGNAME <command> <wid>/[lswArgs]
    n:   Print name of given wid.
    c:   Print class of given wid.
    p:   Print process of given wid.
    na:  Print all names of windows dependant on lswArgs.
    ca:  Print all classes of windows dependant on lswArgs.
    pa:  Print all processes of windows dependant on lswArgs.
    all: Print all names, classes and even window names for matching.
EOF

    test -z $1 && exit 0 || exit $1
}

name() {
    xprop -id $1 WM_CLASS | cut -d\" -f 2
}

class() {
    xprop -id $1 WM_CLASS | cut -d\" -f 4
}

process() {
    xprop -id $1 _NET_WM_PID | cut -d\  -f 3
}

nameAll() {
    for i in $(seq $(lsw | wc -l)); do
        wid=$(lsw | head -n $i | tail -1)
        printf '%s\n' "$wid $(class $wid)"
    done
}

classAll() {
    for i in $(seq $(lsw | wc -l)); do
        wid=$(lsw | head -n $i | tail -1)
        printf '%s\n' "$wid $(class $wid)"
    done
}

processAll() {
    for i in $(seq $(lsw | wc -l)); do
        wid=$(lsw | head -n $i | tail -1)
        printf '%s\n' "$wid $(process $wid)"
    done
}

showAll() {
    nameAll
    classAll

    # find name
    for i in $(seq $(lsw | wc -l)); do
        wid=$(lsw | head -n $i | tail -1)
        printf '%s\n' "$wid $(wname $wid)"
    done
}

main() {
    case $2 in
        0x*)           continue      ;;
        a|all)         lswArgs="-a"  ;;
        # o|override)    lswArgs="-o"  ;;
        # u|unlisted)    lswArgs="-u"  ;;
        # h|help)        usage 1       ;;
    esac

    case $1 in
        n|name)        name $2       ;;
        c|class)       class $2      ;;
        p|process)     process $2    ;;
        na|nameAll)    nameAll       ;;
        ca|classAll)   classAll      ;;
        pa|processAll) processAll    ;;
        a|all)         showAll       ;;
        h|help)        usage         ;;
        *)             usage         ;;
    esac
}

main $ARGS
