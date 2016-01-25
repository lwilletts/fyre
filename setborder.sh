#!/bin/sh
#
# wildefyr & z3bra - 2016 (c) wtfpl
# set or unset a border around a window

ARGS="$@"

usage() { 
    printf '%s\n' "Usage: $(basename $0) <state> <wid>"
    test -z $1 || exit $1
}

main() {
    . fyrerc.sh

    test -z $1 && usage 1

    case $1 in
        none)     
            wattr "$2" || printf '%s\n' "You have not entered a window id."
            chwb -s 0 $2                
            ;;
        active)   
            wattr "$2" || printf '%s\n' "You have not entered a window id."
            chwb -s $BW -c $ACTIVE $2   
            ;;
        warning)  
            wattr "$2" || printf '%s\n' "You have not entered a window id."
            chwb -s $BW -c $WARNING $2 
            ;;
        inactive) 
            chwb -s $BW -c $INACTIVE $2
            ;;
        *) usage 0 ;;
    esac
}

main $ARGS
