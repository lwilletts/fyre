#!/bin/sh
#
# wildefyr - 2016 (c) MIT
# blur current background

ARGS="$@"

usage() {
    cat >&2 << EOF
Usage: $(basename $0) [blur factor]
EOF

    test $# -eq 0 || exit $1
}

main() {
    . fyrerc.sh

    case "$1" in
        h|help) usage 0 ;;
    esac

    test "$#" -eq 0 || intCheck $1

    case "$(lsw | wc -l)" in
        0) BLUR=0 ;;
    esac

    $WALL -blur ${1:-$BLUR}
}

main $ARGS
