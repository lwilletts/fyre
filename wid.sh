#bin/sh
#
# wildefyr - 2016 (c) wtfpl
# wrapper for wclass.sh to find any wid's that match a string
# mainly just for interactive use

ARGS="$@"

usage() { 
    printf '%s\n' "Usage: $(basename $0) <string>"
    test -z $1 || exit $1
}

main() {
    case $1 in
        h|help) usage 0 ;;
    esac
    
    . wclass.sh

    showAll | grep -i $1 | cut -d\  -f 1 | sort | uniq
}

test -z "$ARGS" || main $ARGS
