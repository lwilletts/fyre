#!/bin/mksh
#
# wildefyr & z3bra - 2015 (c) wtfpl
# catch window events from wew

source ~/.config/fyre/fyrerc

blur() {
    BLUR=3
    $(cat $(which bgc) -blur ${1:-$BLUR}) 
}

while IFS=: read ev wid; do
    case $ev in

        4)
            if ! wattr o $wid; then
                focus.sh $wid
            fi
            ;;

        16)
            if ! wattr o $wid; then
                winopen.sh $wid
                test "$(lsw)" = "$wid" && blur &
            fi
            ;;

        18)
            tile.sh mpv
            wattr $(pfw) || vroum.sh prev 2>/dev/null
            test -z "$(lsw)" && blur 0 &
            ;;

        19)
            if ! wattr o $wid; then
                focus.sh $wid
            fi
            ;;

    esac

    case $1 in
        d|debug)
            printf '%s\n' "$ev" 
            ;;
    esac

done
