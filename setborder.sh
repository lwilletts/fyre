#!/bin/sh
#
# wildefyr & z3bra - 2016 (c) wtfpl
# set or unset a border around a window

ARGS="$@"

usage() {
    cat << EOF
Usage: $(basename $0) [state] [wid]
EOF

    test $# -eq 0 || exit $1
}

fnmatch() {
    case "$2" in
        $1) return 0 ;;
        *)  printf '%s\n' "Please enter a valid window id." >&2; exit 1 ;;
    esac
}

main() {
    . fyrerc.sh

    test $# -eq 0 && usage 1
    fnmatch "0x*" "$2"

    case $1 in
        none)
            wattr "$2" || printf '%s\n' "You have not entered a window id." >&2
            chwb -s 0 $2
            ;;
        active)
            wattr "$2" || printf '%s\n' "You have not entered a window id." >&2
            chwb -s $BW -c $ACTIVE $2
            ;;
        warning)
            wattr "$2" || printf '%s\n' "You have not entered a window id." >&2
            chwb -s $BW -c $WARNING $2
            ;;
        inactive)
            chwb -s $BW -c $INACTIVE $2
            ;;
        *) usage 0 ;;
    esac
}

main $ARGS
