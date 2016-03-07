#!/bin/sh
#
# wildefyr & z3bra - 2016 (c) wtfpl
# catch window events from wew

. fyrerc.sh

wew | while IFS=: read ev wid; do
    case $1 in
        -d|--debug) printf '%s\n' "$ev $wid" ;;
    esac

    case $ev in
        4)
            wattr o "$wid" || {
                focus.sh "$wid" "disable"
            }
            ;;
        16)
            wattr o "$wid" || {
                winopen.sh "$wid"
                test $(lsw | wc -l) -eq 1 && blur.sh
            }
            ;;
        17)
            wattr "$(pfw)" || focus.sh prev "disable" 2>/dev/null
            windows.sh -q -c "$wid"
            test "$(lsw | wc -l)" -eq 0 && blur.sh 0
            ;;
        19)
            wattr o "$wid" || {
                windows.sh -q -f "$wid" && focus.sh "$wid"
                test "$(lsw | wc -l)" -ne 0 && blur.sh
            }
            ;;
    esac
done
