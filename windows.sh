#!/bin/sh
#
# wildefyr - 2015 (c) wtfpl
# wrote my own groups script because Greduan's groups.sh was pissing me off

. ~/.config/fyre/fyrerc

usage() {
    printf '%s\n' "usage: $(basename $0) <a|h|s|t|c|r|l> (group) (pfw)"
    exit 1
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

if [ $# -eq 0 ]; then
    usage
fi

case $1 in 
    a|add) add_group ;;
    h|hide) hide_group ;;
    s|show) show_group ;;
    t|toggle) toggle_group ;;
    c|clean) clean_group ;;
    r|reset) reset_groups ;;
    l|list) list_groups ;;
    *) usage ;;
esac
