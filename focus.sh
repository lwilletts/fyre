#!/bin/sh
#
# wildefyr & z3bra - 2016 (c) wtfpl
# focus wrapper with fullscreen check

ARGS="$@"

usage() {
    cat >&2 << EOF
Usage: $(basename $0) <next|prev|full|wid> [disable]
    wid:     Focus the given window id.
    next:    Focus the next window on the stack.
    prev:    Focus the previous window on the stack.
    full:    Focus the fullscreen window.
    disable: Disable movement of the mouse.
EOF

    test $# -eq 0 || exit $1
}

hoverPush() {
    test -f "$HOVER" && {
        while read -r line; do
            wid=$(printf '%s\n' "$line" | cut -d\  -f 1)
            chwso -r $wid
        done < "$HOVER"
    }
}

focusWid() {
    wattr $1 && wid=$1
    focusMethod
}

focusNext() {
    wid=$(lsw | grep -v "$PFW" | sed '1 p;d')
    focusMethod
}

focusPrev() {
    wid=$(lsw | grep -v "$PFW" | sed '$ p;d')
    focusMethod
}

focusFull() {
    test -e $FSFILE && {
        wid=$(cut -d\  -f 5 < $FSFILE) || usage 1
    }
    focusMethod
}

focusMethod() {
    # focus correctly even if there is a fullscreen window
    test -e "$FSFILE" && {
        test "$(cut -d\  -f 5 < $FSFILE)" = "$wid" && {
            setborder.sh none "$wid"
        } || {
            test "$(cut -d\  -f 5 < $FSFILE)" = "$PFW" && {
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

    test "$#" -eq 0 && {
        # automatically focus the window underneath the cursor
        wid=$(underneath)
        test ! -z "$wid" && focusMethod
    } || {
        case $1 in
            0x*)  focusWid $1 ;;
            next) focusNext   ;;
            prev) focusPrev   ;;
            full) focusFull   ;;
            *)    usage 1     ;;
        esac

        case $2 in
            enable)  MOUSE=true  ;;
            disable) MOUSE=false ;;
        esac

        test "$MOUSE" = "true" && moveMouse
    }

    hoverPush
}

for arg in "$ARGS"; do
    case $arg in
        -q|--quiet)      QUIETFLAG=true ;;
        h|help-h|--help) usage 0        ;;
    esac
done

test "$QUIETFLAG" = "true" && {
    main $ARGS 2>&1 > /dev/null
} || {
    main $ARGS
}
