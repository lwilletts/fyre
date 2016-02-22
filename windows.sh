#!/bin/sh
#
# wildefyr - 2016 (c) wtfpl
# personal group script with usablity enchancements

ARGS="$@"

usage() {
    printf '%s\n' "Usage: $(basename $0) <a|h|s|t|c|r|l> (group) (pfw)"
    test -z $1 || exit $1
}

addGroup() {
    echo 1
}

hideGroup() {
    echo 1
}

showGroup() {
    echo 1
}

toggleGroup() {
    echo 1
}

cleanGroup() {
    echo 1
}

resetGroups() {
    echo 1
}

listGroups() {
    printf '%s\n' "Existing groups:"
    ls $GROUPSDIR
}

main() {
    . fyrerc.sh

    for arg in $ARGS; do
        case $arg in
            -a|--add)    add_group    ;;
            -h|--hide)   hide_group   ;;
            -s|--show)   show_group   ;;
            -t|--toggle) toggle_group ;;
            -c|--clean)  clean_group  ;;
            -r|--reset)  reset_groups ;;
            -l|--list)   list_groups  ;;
            *)           usage 0      ;;
        esac
    done
}

for arg in $ARGS; do
    case $arg in
        -q|--quiet) QUIETFLAG=true ;;
    esac
done

test "$QUIETFLAG" = "true" && {
    main $ARGS 2>&1 > /dev/null
} || {
    main $ARGS
}
