#!/bin/sh
#
# wildefyr & z3bra - 2016 (c) wtfpl
# focus wrapper with fullscreen checks

readonly PROGNAME=$(basename $0)
readonly PROGDIR=$(readlink -m $(dirname $0))
readonly PROGPATH=${PROGPATH:-$PROGDIR/$PROGNAME}
ARGS="$@"

usage() {
    printf '%s\n' "Usage: $PROGNAME <next|prev|full|wid>"
    test -z $1 && exit 0 || exit $1
}

main() {
    . fyrerc.sh

    case $1 in
        full) test -e $FSFILE && wid=$(cat $FSFILE | cut -d\  -f 5) || usage 1 ;;
        next) wid=$(lsw | grep -v $CUR | sed '1 p;d')                          ;;
        prev) wid=$(lsw | grep -v $CUR | sed '$ p;d')                          ;;
        0x*)  wattr $1 && wid=$1                                               ;;
        *)    usage                                                            ;;
    esac

    chwso -r $wid
    wtf $wid

    # focus correctly even if there is a fullscreen window
    test -e "$FSFILE" && {
        if [ "$(cat $FSFILE | cut -d\  -f 5)" = "$wid" ]; then
            setborder.sh none $wid
        elif [ "$(cat $FSFILE | cut -d\  -f 5)" = "$CUR" ]; then
            setborder.sh active $wid
            setborder.sh none $CUR
        else
            if [ "$wid" != "$CUR" ]; then
                setborder.sh active $wid
                setborder.sh inactive $CUR
            fi
        fi 
    } || {
        test "$wid" != "$CUR" && \
            setborder.sh active $wid
            setborder.sh inactive $CUR
        }

    # move mouse to the middle of the window
    wmp -a $(wattr xy $wid)
    wmp -r $(($(wattr w $wid) / 2)) $(($(wattr h $wid) / 2))
}

main $ARGS
