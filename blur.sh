#!/bin/sh
#
# wildefyr - 2016 (c) wtfpl
# blur current background

ARGS="$@"

usage() {
    cat << EOF
Usage: $(basename $0) [blur factor]
EOF

    test $# -eq 0 || exit $1
}

intCheck() {
    test $1 -ne 0 2> /dev/null
    test $? -ne 2 || {
         printf '%s\n' "'$1' is not an integer." >&2
         exit 1
    }
}

main() {
    . fyrerc.sh

    case $1 in
        h|help) usage 0 ;;
    esac

    test $# -eq 0 || intCheck $1

    $WALL -blur ${1:-$BLUR}
}

main $ARGS
