#bin/sh
#
# wildefyr - 2016 (c) MIT
# wrapper to find any visible window that matches a string

ARGS="$@"

usage() {
    cat << EOF
Usage: $(basename $0) [Search String]
EOF

    test $# -eq 0 || exit $1
}

nameAll() {
    for wid in $(lsw); do
        printf '%s\n' "$wid $(name $wid)"
    done
}

classAll() {
    for wid in $(lsw); do
        printf '%s\n' "$wid $(class $wid)"
    done
}

titleAll() {
    for wid in $(lsw); do
        printf '%s\n' "$wid $(wname $wid)"
    done
}

showAll() {
    nameAll
    classAll
    titleAll
}

main() {
    . fyrerc.sh

    case $1 in
        h|help|-h|--help) usage 0 ;;
    esac

    showAll | grep -wi "$1" | cut -d\  -f 1 | sort | uniq
}

test -z "$ARGS" || main $ARGS
