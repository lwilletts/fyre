#!/bin/sh
#
# wildefyr & z3bra - 2016 (c) wtfpl
# set or unset a border around a window

. fyrerc.sh

readonly PROGNAME=$(basename $0)
readonly PROGDIR=$(readlink -m $(dirname $0))
readonly PROGPATH=${PROGPATH:-$PROGDIR/$PROGNAME}
ARGS="$@"

usage() { 
    printf '%s\n' "Usage: $PROGNAME <state> <wid>"
    test -z $1 && exit 0 || exit $1
}

main() {
    # check arguments
    test -z $1 && usage 1
    wattr $2 || usage 1

    case $1 in
        none)     chwb -s 0 $2                ;;
        active)   chwb -s $BW -c $ACTIVE $2   ;;
        warning)  chwb -s $BW -c $WARNING $2  ;;
        inactive) chwb -s $BW -c $INACTIVE $2 ;;
        h|help)   usage                       ;;
        *)        usage                       ;;
    esac
}

main $ARGS
