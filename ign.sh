#!/bin/sh
#
# wildefyr - 2016 (c) MIT
# toggle for ignw and override_redirect

usage() {
    cat << EOF
Usage: $(basename $0) [wid]
EOF

    test $# -eq 0 || exit $1
}

. fyrerc.sh

case $1 in
    0x*) PFW=$1  ;;
    *)   usage 0 ;;
esac

wattr o "$PFW" && {
    ignw -r "$PFW"
    buffer=$(grep -wv "$PFW" "$IGNORE")
    test -z "$buffer" 2> /dev/null && {
        rm -f "$IGNORE"
    } || {
        printf '%s\n' "$buffer" > "$IGNORE"
    }
} || {
    ignw -s "$PFW"
    printf '%s\n' "$PFW" >> "$IGNORE"
}
