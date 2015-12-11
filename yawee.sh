#!/bin/sh
#
# wildefyr & z3bra - 2015 (c) wtfpl
# catch window events from wew

. ~/.config/fyre/fyrerc

while IFS=: read ev wid; do
    case $ev in

        4)
            if ! wattr o $wid; then
                focus.sh $wid
            fi
            ;;

        16)
            if ! wattr o $wid; then
                $FYREDIR/winopen $wid
                if [ $(lsw | wc -l) -eq 1 ]; then
                    blur.sh &
                fi
            fi
            ;;

        18)
            tile.sh
            wattr $(pfw) || vroum.sh prev 2>/dev/null
            if [ $(lsw | wc -l) -eq 0 ]; then
                blur.sh 0 &
            fi
            ;;

        19)
            if ! wattr o $wid; then
                tile.sh
                focus.sh $wid
                if [ $(lsw | wc -l) -ne 0 ]; then
                    blur.sh &
                fi
            fi
            ;;

    esac

    case $1 in
        d|debug)
            printf '%s\n' "$ev" 
            ;;
    esac

done
