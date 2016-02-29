#!/bin/sh
#
# wildefyr && grendun - 2016 (c) wtfpl
# groups script with usablity enchancements

ARGS="$@"

usage() {
    cat << EOF
Usage: $(basename $0)
EOF

    test $# -eq 0 || exit $1
}

intCheck() {
    test $1 -ne 0 2> /dev/null
    test $? -ne 2 || {
         printf '%s\n' "'$1' is not an integer." >&2
         exit 1
    }
}

fnmatch() {
    case "$2" in
        $1) return 0 ;;
        *)  printf '%s\n' "Please enter a valid window id." >&2; exit 1 ;;
    esac
}

clean_wid() {
    wid=$1
    fnmatch "0x*" "$wid"

    for group in $GROUPSDIR/*.?; do
        buffer=$(cat $group | sed "s/$wid//" )
        printf '%s\n' "$buffer" | sed '/^\s*$/d' > $group
        test -z "$(cat $group)" 2> /dev/null && clean_group "$group"
    done

    unset $buffer
    printf '%s\n' "$(name $wid) ($wid) cleaned!"
}

clean_group() {
    group=$1
    intCheck "$group"

    test -f $GROUPSDIR/group.${group} && {
        # make the group visible
        show_group "$group"
        rm -f $GROUPSDIR/group.${group}
        printf '%s\n' "group ${group} cleaned!"
    } || {
        printf '%s\n' "group ${group} does not exist!" >&2
    }
}

add_to_group() {
    test ! -z $3 && usage 1

    wid=$(printf "$1" | cut -d\  -f 1)
    group=$(printf '%s' "$1" | cut -d\  -f 2)

    fnmatch "0x*" "$wid"
    intCheck "$group"
}

hide_group() {
    group=$1
    intCheck "$group"
    clean_status "$group"
}

show_group() {
    group=$1
    intCheck "$group"

    printf '%s' "$group" >> $GROUPSDIR/active

    for group in $GROUPSDIR/*.?; do
    done

    for wid in $(cat $GROUPSDIR/group.${group}); do
        mapw -m $wid
    done
}

toggle_group() {
    group=$1
    intCheck "$group"
}

unmap_group() {
    group=$1
    intCheck "$group"
}

reset_groups() {
    return
}

list_groups() {
    for group in $GROUPSDIR/*.?; do
        printf '%s\n' "$(printf '%s' ${group} | rev | cut -d'/' -f 1 | rev):"
        cat "${group}"
    done
}

main() {
    . fyrerc.sh

    for arg in $ARGS; do
        case $arg in -?|--*) ADDFLAG=false ;; esac
        test "$ADDFLAG" = "true" && ADDSTRING="${ADDSTRING}${arg} "
        case $arg in -a|--add) ADDFLAG=true ;; esac
    done

    test ! -z "$ADDSTRING" && {
        add_to_group "$ADDSTRING"
    }

    for arg in $ARGS; do
        test "$SHOWFLAG"       = "true" && show_group "$arg"   && SHOWFLAG=false
        test "$HIDEFLAG"       = "true" && hide_group "$arg"   && HIDEFLAG=false
        test "$CLEANFLAG"      = "true" && clean_wid "$arg"    && CLEANFLAG=false
        test "$UNMAPFLAG"      = "true" && unmap_group "$arg"  && UNMAPFLAG=false
        test "$TOGGLEFLAG"     = "true" && toggle_group "$arg" && TOGGLEFLAG=false
        test "$CLEANGROUPFLAG" = "true" && clean_group "$arg"  && TOGGLEFLAG=false

        case $arg in
            -s|--show)       SHOWFLAG=true       ;;
            -h|--hide)       HIDEFLAG=true       ;;
            -c|--cleanwid)   CLEANFLAG=true      ;;
            -C|--cleangroup) CLEANGROUPFLAG=true ;;
            -u|--unmap)      UNMAPFLAG=true      ;;
            -t|--toggle)     TOGGLEFLAG=true     ;;
            -r|--reset)      reset_groups        ;;
            -l|--list)       list_groups         ;;
        esac
    done
}

test "$#" -eq 0 && usage 1

for arg in $ARGS; do
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
