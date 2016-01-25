#!/bin/sh
#
# wildefyr - 2016 (c) wtfpl
# set xprop flag to ignore a window

ARGS="$@"

usage() {
    cat << EOF
Usage: $(basename $0) <option>
EOF

    test -z $1 || exit $1
}

setIgnore() {
    case $1 in
        0x*) wid=$1 ;;
        *)   echo "Failed to execute function." && return ;;
    esac

    xprop -id $wid -f _FYRE_IGNORE 8i -set _FYRE_IGNORE '1'
}

setUnignore() {
    case $1 in
        0x*) wid=$1 ;;
        *)   echo "Failed to execute function." && return ;;
    esac

    xprop -id $wid -f _FYRE_IGNORE 8i -set _FYRE_IGNORE '0'
}

toggleIgnore() {
    case $1 in
        0x*) wid=$1 ;;
        *)   echo "Failed to execute function." && return ;;
    esac

    ignoreStatus=$(xprop -id $wid _FYRE_IGNORE | cut -d\  -f 3)
    case $ignoreStatus in
        1) setUnignore ;;
        *) setIgnore   ;;
    esac
    
}

testIgnore() {
    case $1 in
        0x*) wid=$1 ;;
        *)   echo "Failed to execute function." && return ;;
    esac

    ignoreStatus=$(xprop -id $wid _FYRE_IGNORE | cut -d\  -f 3)
    case $ignoreStatus in
        1) echo "1" ;;
        *) echo "0" ;;
    esac
}

main() {
    . fyrerc.sh

    case $2 in
        0x*) PFW=$2 ;;
    esac

    case $1 in
        i|ignore)   setIgnore $PFW    ;;
        u|uningore) setUnignore $PFW  ;;
        t|toggle)   toggleIgnore $PFW ;;
        s|status)   testIgnore $PFW   ;;
        *)          usage 0           ;;
    esac
}

test -z "$ARGS" || main $ARGS
