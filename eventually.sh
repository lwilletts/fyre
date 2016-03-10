#!/bin/sh
#
# wildefyr & z3bra - 2016 (c) wtfpl
# catch window events from wew

wew | while IFS=: read ev wid; do
    . fyrerc.sh

    case "$ev" in
        7)
            test "$MOUSE" = "true" && {
                wattr o "$wid" || {
                    focus.sh "$wid" "disable" -q
                }
            }
            ;;
        16)
            wattr o "$wid" || {
                winopen.sh "$wid"
                test $(lsw | wc -l) -eq 1 && blur.sh
            }
            ;;
        17)
            wattr "$(pfw)" || focus.sh prev "disable" -q
            test -f "$FSFILE" && {
                test "$(cut -d\  -f 5 < $FSFILE)" = "$wid" && rm -f "$FSFILE"
            }
            windows.sh -q -c "$wid"
            test "$(lsw | wc -l)" -eq 0 && blur.sh 0
            ;;
        19)
            wattr o "$wid" || {
                windows.sh -q -f "$wid" && focus.sh "$wid" "disable" -q
                test "$(lsw | wc -l)" -ne 0 && blur.sh
            }
            ;;
    esac
done
