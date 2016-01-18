#!/bin/sh
#
# wildefyr - 2016 (c) wtfpl
# blur current background

readonly PROGNAME=$(basename $0)
readonly PROGDIR=$(readlink -m $(dirname $0))
readonly PROGPATH=${PROGPATH:-$PROGDIR/$PROGNAME}
ARGS="$@"

usage() {
    printf '%s\n' "Usage: $PROGNAME [blur factor]"
    test -z $1 && exit 0 || exit $1
}

main() {
    . fyrerc.sh

    case $1 in
        h|help) usage ;;
    esac

    hsetroot $WALL -blur ${1:-$BLUR}
}

main $ARGS
