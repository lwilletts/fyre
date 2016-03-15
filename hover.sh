#!/bin/sh
#
# wildefyr - 2016 (c) MIT
# make the window 'hover' over others

ARGS="$@"

usage() {
    cat >&2 << EOF
Usage: $(basename $0) [wid]
EOF

    test $# -eq 0 || exit $1
}

fnmatch() {
    case "$2" in
        $1) return 0 ;;
        *)  printf '%s\n' "Please enter a valid window id." >&2; exit 1 ;;
    esac
}


clean_hover() {
    cleanWid=$1
    fnmatch "0x*" "$cleanWid"

    . fyrerc.sh

    test -f "$HOVER" && {
        grep -q "$cleanWid" "$HOVER" && {
            while read -r line; do
                searchWid=$(printf '%s\n' "$line" | cut -d\  -f 1)
                test "$searchWid" = $cleanWid && {
                    buffer=$(grep -wv "$cleanWid" "$HOVER")
                    test -z "$buffer" 2> /dev/null && {
                        rm -f "$HOVER"
                    } || {
                        printf '%s\n' "$buffer" > "$HOVER"
                    }
                    return 0
                }
            done < "$HOVER"
        }
    }
}

main() {
    hoverWid=$1
    fnmatch "0x*" "$hoverWid"

    . fyrerc.sh

    test -f "$HOVER" && {
        while read -r line; do
            searchWid=$(printf '%s\n' "$line" | cut -d\  -f 1)
            test "$searchWid" = $hoverWid && {
                buffer=$(grep -wv "$hoverWid" "$HOVER")
                test -z "$buffer" 2> /dev/null && {
                    rm -f "$HOVER"
                } || {
                    printf '%s\n' "$buffer" > "$HOVER"
                }

                ignw -r "$hoverWid"

                groupId=$(printf '%s\n' "$line" | awk '{print $2}')
                test -z "$groupId" && {
                    windows.sh -c "$hoverWid"
                } || {
                    windows.sh -a "$hoverWid" "$groupId"
                }

                return 0
            }
        done < "$HOVER"
    }

    currentGroup=$(windows.sh -f "$hoverWid")
    currentGroup=$(printf '%s\n' "$currentGroup" | rev | cut -d'.' -f 1 | rev)
    test -z "$currentGroup" && {
        printf '%s\n' "$hoverWid" >> "$HOVER"
    } || {
        printf '%s\n' "$hoverWid $currentGroup" >> "$HOVER"
    }

    windows.sh -a "$hoverWid" 9
    ignw -s "$hoverWid"
}

test "$#" -eq 0 && usage 1

for arg in $ARGS; do
    test "$CLEANFLAG" = "true" && clean_hover "$arg" && exit

    case $arg in
        -c|--clean)      CLEANFLAG=true ;;
        -q|--quiet)      QUIETFLAG=true ;;
        h|help-h|--help) usage 0        ;;
    esac
done

test "$QUIETFLAG" = "true" && {
    main $ARGS 2>&1 > /dev/null
} || {
    main $ARGS
}
