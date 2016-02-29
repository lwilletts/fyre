#!/bin/sh
#
# wildefyr & z3bra - 2016 (c) wtfpl
# focus wrapper with fullscreen check

ARGS="$@"

usage() {
    cat << EOF
Usage: $(basename $0) <next|prev|full|wid> [disable]
    wid:     Focus the given window id.
    next:    Focus the next window on the stack.
    prev:    Focus the previous window on the stack.
    full:    Focus the fullscreen window.
    disable: Disable movement of the mouse.
EOF

    test $# -eq 0 || exit $1
}

focusWid() {
    wattr $1 && wid=$1
    focusMethod
}

focusNext() {
    wid=$(lsw | grep -v $PFW | sed '1 p;d')
    focusMethod
}

focusPrev() {
    wid=$(lsw | grep -v $PFW | sed '$ p;d')
    focusMethod
}

focusFull() {
    test -e $FSFILE && {
        wid=$(cat $FSFILE | cut -d\  -f 5) || usage 1
    }
    focusMethod
}

focusMethod() {
    # focus correctly even if there is a fullscreen window
    test -e "$FSFILE" && {
        test "$(cat $FSFILE | cut -d\  -f 5)" = "$wid" && {
            setborder.sh none "$wid"
        } || {
            test "$(cat $FSFILE | cut -d\  -f 5)" = "$PFW" && {
                setborder.sh active "$wid"
                setborder.sh none "$PFW"
            }
        }
    } || {
        test "$wid" != "$PFW" && {
            setborder.sh active "$wid"
            setborder.sh inactive "$PFW"
        }
    }

    chwso -r $wid
    wtf $wid
}

moveMouse() {
    . mouse.sh

    mouseStatus=$(getMouseStatus)
    test "$mouseStatus" -eq 1 && moveMouseEnabled $wid
}

main() {
    . fyrerc.sh

    case $1 in
        0x*)              focusWid  $1 ;;
        next)             focusNext    ;;
        prev)             focusPrev    ;;
        full)             focusFull    ;;
        h|help|-h|--help) usage 0      ;;
        *)                usage 1      ;;
    esac

    case $2 in
        disable) MOUSE=false ;;
        *)       MOUSE=true  ;;
    esac

    test "$MOUSE" = "true" && moveMouse
}

main $ARGS
