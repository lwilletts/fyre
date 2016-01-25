#!/bin/sh
#
# wildefyr - 2016 (c) wtfpl
# use slop to get xywh position for urxvt window

ARGS="$@"

usage() {
    cat << EOF
Usage: $(basename $0) ARGUMENTS
    c | cmd:  Terminal command to run.
    h | help: Show this help.
EOF

    test -z $1 || exit $1
}

main() {
    . fyrerc.sh

    for arg in "$@"; do
        case $arg in
            -c|--cmd)   COMMANDFLAG=true ;;
            -h|--help)  usage 0          ;;
        esac

        case $arg in
            -*)  continue ;;
            --*) continue ;;
        esac

        test "$COMMANDFLAG" = "true" && \
            CMDSTRING="$CMDSTRING $arg"
    done

    eval $(slop -t 0 -b $BW '215,215,215,0.9')

    test ! -z "$CMDSTRING" && \
        urxvt -name 'slop' -e zsh -c "$CMDSTRING" || \
        urxvt -name 'slop' &

    sleep 0.05
    wtp $X $Y $W $H $(wid.sh "slop" | tail -1)
}

main $ARGS
