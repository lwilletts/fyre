#!/bin/dash
#
# wildefyr - 2015 (c) wtfpl
# wrote my own groups script because Greduan's groups.sh was pissing me off

. ~/.config/fyre/fyrerc

usage() {
    printf '%s\n' "usage: $(basename $0) <add|hide|show|toggle|clean|reset|list> (group) (pfw)"
    exit 1
}

add_group() {
}

hide_group() {
}

show_group() {
}

toggle_group() {
}

clean_group() {
}

reset_groups() {
}

list_groups() {
}

if [ $# -eq 0 ]; then
    usage
fi

case $1 in 
    a|add)
        add_group ;;
    h|hide)
        hide_group ;;
    s|show)
        show_group ;;
    t|toggle)
        toggle_group ;;
    c|clean)
        clean_group ;;
    r|reset)
        reset_groups ;;
    l|list)
        list_groups ;;
esac
