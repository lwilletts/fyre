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

    test -z $1 && exit 0 || exit $1
}

focusWid() {
    . fyrerc.sh

    wattr $1 && wid=$1
    focusMethod
}

focusNext() {
    . fyrerc.sh

    wid=$(lsw | grep -v $PFW | sed '1 p;d')
    focusMethod
}

focusPrev() {
    . fyrerc.sh

    wid=$(lsw | grep -v $PFW | sed '$ p;d')
    focusMethod
}

focusFull() {
    . fyrerc.sh

    test -e $FSFILE && \
        wid=$(cat $FSFILE | cut -d\  -f 5) || usage 1
    focusMethod
}

focusMethod() {
    # focus correctly even if there is a fullscreen window
    if [ -e "$FSFILE" ]; then
        if [ "$(cat $FSFILE | cut -d\  -f 5)" = "$wid" ]; then
            setborder.sh none $wid
        elif [ "$(cat $FSFILE | cut -d\  -f 5)" = "$PFW" ]; then
            setborder.sh active $wid
            setborder.sh none $PFW
        else
            if [ "$wid" != "$PFW" ]; then
                setborder.sh active $wid
                setborder.sh inactive $PFW
            fi
        fi
    else
        if [ "$wid" != "$PFW" ]; then
            setborder.sh active $wid
            setborder.sh inactive $PFW
        fi
    fi

    chwso -r $wid
    wtf $wid
}

moveMouse() {
    . mouse.sh

    mouseStatus=$(getMouseStatus)
    test "$mouseStatus" -eq 1 && {
        # move mouse to the middle of the window
        wmp -a $(wattr xy $wid)
        wmp -r $(($(wattr w $wid) / 2)) $(($(wattr h $wid) / 2))
    }
}

main() {
    case $1 in
        0x*)    focusWid  $1 ;;
        next)   focusNext    ;;
        prev)   focusPrev    ;;
        full)   focusFull    ;;
        h|help) usage        ;;
        *)      usage        ;;
    esac

    case $2 in
        disable) MOUSE=false ;;
        *)       MOUSE=true  ;;
    esac

    test "$MOUSE" = "true" && moveMouse
}

test -z "$ARGS" || main $ARGS
