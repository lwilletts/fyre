#!/bin/mksh
#
# wildefyr & z3bra - 2015 (c) wtfpl
# catch window events from wew

source ~/.config/fyre/fyrerc

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
                if [ $(lsw | wc -l) -eq 1 ]; then
                    blur &
                fi
            fi
            ;;

        18)
            tile.sh mpv
            wattr $(pfw) || vroum.sh prev 2>/dev/null
            if [ $(lsw | wc -l) -eq 0 ]; then
                blur 0 &
            fi
            ;;

        19)
            if ! wattr o $wid; then
                tile.sh mpv
                focus.sh $wid
                if [ $(lsw | wc -l) -ne 0 ]; then
                    blur &
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
