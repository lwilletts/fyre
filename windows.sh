#!/bin/sh
#
# wildefyr - 2016 (c) wtfpl
# personal group script with usablity enchancements

ARGS="$@"

usage() {
    printf '%s\n' "Usage: $(basename $0) <a|h|s|t|c|r|l> (group) (pfw)"
    test -z $1 || exit $1
}

add_group() {
    echo 1
}

hide_group() {
    echo 1
}

show_group() {
    echo 1
}

toggle_group() {
    echo 1
}

clean_group() {
    echo 1
}

reset_groups() {
    echo 1
}

list_groups() {
    vcat $GROUPSDIR/*.*
}

main() {
    . fyrerc.sh

    case $1 in 
        a|add)    add_group    ;;
        h|hide)   hide_group   ;;
        s|show)   show_group   ;;
        t|toggle) toggle_group ;;
        c|clean)  clean_group  ;;
        r|reset)  reset_groups ;;
        l|list)   list_groups  ;;
        *)        usage 0      ;;
    esac
}

test -z "$ARGS" || main $ARGS
