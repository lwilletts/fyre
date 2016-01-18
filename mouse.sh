#!/bin/sh
#
# wildefyr - 2016 (c) wtfpl
# enable / disable mouse based on input

readonly PROGNAME=$(basename $0)
readonly PROGDIR=$(readlink -m $(dirname $0))
readonly PROGPATH=${PROGPATH:-$PROGDIR/$PROGNAME}
ARGS="$@"


usage() {
    printf '%s\n' "Usage: $PROGNAME <enable|disable>"
    test -z $1 && exit 0 || exit $1
}

main() {
    . fyrerc.sh

    case $1 in
        e|enable)
            xinput set-int-prop $(xinput | \
            awk '/Mouse/ {printf "%s",$9}' | sed 's/id=//') "Device Enabled" 8 1
            ;;
        d|disable)
            wmp $SW $SH
            xinput set-int-prop $(xinput | \
            awk '/Mouse/ {printf "%s",$9}' | sed 's/id=//') "Device Enabled" 8 0
            ;;
        h|help) usage ;;
        *)      usage ;;
    esac
}

main $ARGS
