#!/bin/sh
#
# wildefyr - 2016 (c) wtfpl
# blur current background

ARGS="$@"

usage() {
    printf '%s\n' "Usage: $(basename $0) [blur factor]"
    test -z $1 && exit 0 || exit $1
}

main() {
    . fyrerc.sh

    case $1 in
        h|help) usage ;;
    esac

    test "$1" != "" && \
        test $1 -ne 0 > /dev/null
        test $? -ne 2 || {
            printf '%s\n' "$1 is not an integer." >&2
            exit 1
        }

    hsetroot $WALL -blur ${1:-$BLUR}
}

main $ARGS
