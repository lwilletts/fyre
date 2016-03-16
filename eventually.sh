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

        cat << EOF
$ev $wid
$(name $wid)
$(wname $wid)
$(class $wid)
$(process $wid)

EOF
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
            case "$WOKRFLOW" in
                "workspaces")
                    windows.sh -q -a "$wid" "$(cat $active)"
                    ;;
                *)
                    wattr o "$wid" || winopen.sh "$wid"
                    ;;
            esac

            blur.sh
            ;;
        17)
            # clean workspace/group
            windows.sh -q -c "$wid"

            # clean hover
            hover.sh -c "$wid"
            # clean fullscreen
            test -f "$FSFILE" && \
                test "$(cut -d\  -f 5 < $FSFILE)" = "$wid" && rm -f "$FSFILE"
            ;;
        18)
            wattr "$(pfw)" || focus.sh prev "disable" -q

            blur.sh
            ;;
        19)
            blur.sh
            ;;
    esac
done
