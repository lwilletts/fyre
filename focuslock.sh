#!/bin/sh
#
# wildefyr - 2016 (c) wtfpl
# sets xprop focus information to let closest.sh 'pass' over windows

ARGS="$@"

usage() {
    printf '%s\n' "Usage: $(basename $0) "
    test -z $1 && exit 0 || exit $1
}

main() {
    . fyrerc.sh
}

test -z "$ARGS" || main $ARGS
