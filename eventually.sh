#!/bin/sh
#
# wildefyr & z3bra - 2016 (c) wtfpl
# catch window events from wew

usage() {
    cat >&2 << EOF
Usage: $(basename $0) [-d|--debug] [-h|--help]
EOF

    test $# -eq 0 || exit $1
}

case $1 in
    -d|--debug)
        . fyrerc.sh

        wew | while IFS=: read -r ev wid; do
            printf '%s\n' "$ev $wid $(name $wid) $(class $wid) $(process $wid)"
        done
        ;;
    h|help|-h|--help)
        usage 0
        ;;
esac

wew | while IFS=: read ev wid; do
    . fyrerc.sh

    case "$ev" in
        7)
            test "$SLOPPY" = "true" && {
                wattr o "$wid" || {
                    focus.sh "$wid" "disable" -q
                }
            }
            ;;
        16)
            wattr o "$wid" || winopen.sh "$wid"

            test $(lsw | wc -l) -eq 1 && blur.sh
            ;;
        17)
            # clean group
            windows.sh -q -c "$wid"
            # clean hover
            test -f "$HOVER" && hover.sh -c "$wid"
            # clean fullscreen
            test -f "$FSFILE" && \
                test "$(cut -d\  -f 5 < $FSFILE)" = "$wid" && rm -f "$FSFILE"

            test "$(lsw | wc -l)" -eq 0 && blur.sh 0
            ;;
        18)
            wattr "$(pfw)" || focus.sh prev "disable" -q
            ;;
        19)
            wattr o "$wid" || {
                windows.sh -q -f "$wid" && focus.sh "$wid" "disable" -q
            }

            test "$(lsw | wc -l)" -ne 0 && blur.sh
            ;;
    esac
done
