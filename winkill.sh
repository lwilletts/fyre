#!/bin/sh
#
# wildefyr - 2016 (c) wtfpl
# performs checks when window has been targetted for termination

ARGS="$@"

usage() {
    printf '%s\n' "Usage: $(basename $0) <wid>"
    test -z $1 || exit $1
}

main() {
    case $1 in
        0x*) wid=$1  ;;
        *)   usage 0 ;;
    esac

    printf '%s\n' "you're terminated fucker."
    killwa $wid
}

main $ARGS
