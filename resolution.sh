#!/bin/sh
#
# wildefyr - 2016 (c) wtfpl
# find resoluton of mpv video based on window id

readonly PROGNAME=$(basename $0)
readonly PROGDIR=$(readlink -m $(dirname $0))
readonly PROGPATH=${PROGPATH:-$PROGDIR/$PROGNAME}
ARGS="$@"

usage() {
    printf '%s\n' "Usage: $PROGNAME <mpvwid>"
    test -z $1 && exit 0 || exit $1
}

main () {
    test -z $1 && usage 1

    wid=$1

    test "$(wclass.sh c $wid)" = "mpv" && \
        printf '%s\n' "$(xprop -id $wid WM_NORMAL_HINTS | sed '5s/[^0-9]*//p;d' | tr / \ )" || \
            printf '%s\n' "Please enter a valid mpv wid" >&2
            usage 1
}

main $ARGS
