#!/bin/sh
#
# wildefyr - 2016 (c) wtfpl
# sets xprop focus information to let closest.sh 'pass' over windows

readonly PROGNAME=$(basename $0)
readonly PROGDIR=$(readlink -m $(dirname $0))
readonly PROGPATH=${PROGPATH:-$PROGDIR/$PROGNAME}
ARGS="$@"

usage() {
    printf '%s\n' "Usage: $PROGNAME "
    test -z $1 && exit 0 || exit $1
}

main() {
    . fyrerc.sh
}

main $ARGS
