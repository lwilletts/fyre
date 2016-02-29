#!/bin/sh
#
# wildefyr && greduan - 2016 (c) wtfpl
# groups script with usablity enchancements

ARGS="$@"

usage() {
    cat << EOF
Usage: $(basename $0) [-a wid group] [-fc wid] [-shtu group] [-rlhq]
    -a | --add:    Add a wid to a group.
    -f | --find:   Outputs wid if it was not found in a group.
    -c | --clean:  Clean wid from all groups.
    -s | --show:   Show given group.
    -h | --hide:   Hide given group.
    -t | --toggle: Toggle given group.
    -u | --unmap:  Unmap given group.
    -r | --reset:  Reset all groups.
    -l | --list:   List all groups.
    -q | --quiet:  Suppress all textual output.
    -h | --help:   Show this help.
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

find_wid() {
    wid=$1
    fnmatch "0x*" "$wid"

    for group in $(find $GROUPSDIR/*.? 2> /dev/null); do
        grep -q "$wid" "$group" && {
            groupNum=$(printf '%s\n' "$group" | rev | cut -d'.' -f 1 | rev)
            printf '%s\n' "$wid was found in group ${groupNum}."
            exit 1
        }
    done

    printf '%s\n' "$wid was not found in any group."
    exit 0
}

clean_wid() {
    wid=$1
    fnmatch "0x*" "$wid"

    for group in $(find $GROUPSDIR/*.? 2> /dev/null); do
        buffer=$(sed "s/$wid//" < $group)
        printf '%s\n' "$buffer" | sed '/^\s*$/d' > "$group"
        test -z "$(cat $group)" 2> /dev/null && {
            groupNum=$(printf '%s\n' "$group" | rev | cut -d'.' -f 1 | rev)
            unmap_group "$groupNum" 2>&1 > /dev/null
        }
    done

    printf '%s\n' "$(class $wid) ($wid) cleaned!"
}

unmap_group() {
    group=$1
    intCheck "$group"

    test -f "$GROUPSDIR/group.${group}" && {
        # make the group visible
        show_group "$group"
        # clean group from active file
        buffer=$(cat "$GROUPSDIR/active" | sed "s/$group//")
        printf '%s\n' "$buffer" | sed '/^\s*$/d' > "$GROUPSDIR/active"
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

    test -f "$GROUPSDIR/inactive" && {
        while read -r inactive; do
            test "$inactive" -eq "$group" && {
                inactiveFlag=true
                break
            }
        done < $GROUPSDIR/inactive
    }
    test -f "$GROUPSDIR/inactive" && {
        while read -r active; do
            test "$active" -eq "$group" && {
                activeFlag=true
                break
            }
        done < $GROUPSDIR/active
    }

    test "$inactiveFlag" = "true" && {
        mapw -u $wid
    }
    test "$activeFlag" != "true" && {
        printf '%s\n' "$group" >> "$GROUPSDIR/active"
    }

    grep -q "$wid" "$GROUPSDIR/group.${group}" 2> /dev/null && {
        printf '%s\n' "$(class $wid) ($wid) already exists in ${group}!"
    } || {
        printf '%s\n' "$wid" >> $GROUPSDIR/group.${group}
        printf '%s\n' "$(class $wid) ($wid) added to ${group}!"
    }
}

hide_group() {
    group=$1
    intCheck "$group"

    printf '%s\n' "$group" >> "$GROUPSDIR/inactive"

    buffer=$(cat "$GROUPSDIR/active" | sed "s/$group//")
    printf '%s\n' "$buffer" | sed '/^\s*$/d' > "$GROUPSDIR/active"

    while read -r wid; do
        mapw -u $wid
    done < $GROUPSDIR/group.${group}

    printf '%s\n' "group ${group} hidden!"
}

show_group() {
    group=$1
    intCheck "$group"

    printf '%s\n' "$group" >> "$GROUPSDIR/active"

    buffer=$(cat "$GROUPSDIR/inactive" | sed "s/$group//")
    printf '%s\n' "$buffer" | sed '/^\s*$/d' > "$GROUPSDIR/inactive"

    while read -r wid; do
        mapw -m $wid
    done < "$GROUPSDIR/group.${group}"

    printf '%s\n' "group ${group} visible!"
}

toggle_group() {
    group=$1
    intCheck "$group"

    activeFlag=false

    while read -r active; do
        test "$active" -eq "$group" && {
            activeFlag=true
            break
        }
    done < "$GROUPSDIR/active"


    test "$activeFlag" = "true" && {
        while read -r wid; do
            test "$(pfw)" = $wid && {
                hide_group "$group"
            } || {
                focus.sh "$wid" "disable"
                return 0
            }
        done < $GROUPSDIR/group.${group}
    } || {
        show_group "$group"
        wid=$(cat "$GROUPSDIR/group.${group}" | head -n 1)
        focus.sh "$wid"
    }
}

reset_groups() {
    while read -r group; do
        show_group "$group"
    done < "$GROUPSDIR/inactive"

    rm -f $GROUPSDIR/*
}

list_groups() {
    for group in $(find $GROUPSDIR/*.? 2> /dev/null); do
        printf '%s\n' "$(printf '%s' ${group} | rev | cut -d'/' -f 1 | rev):"
        printf '%s\n' "$(cat ${group}) - $(class $(cat ${group}))"
    done
}

main() {
    . fyrerc.sh

    for arg in "$@"; do
        case "$arg" in -?|--*) ADDFLAG=false ;; esac
        test "$ADDFLAG" = "true" && ADDSTRING="${ADDSTRING}${arg} "
        case "$arg" in -a|--add) ADDFLAG=true ;; esac
    done

    test ! -z "$ADDSTRING" && {
        add_to_group "$ADDSTRING"
    }

    for arg in "$@"; do
        test "$SHOWFLAG"   = "true" && show_group "$arg"   && SHOWFLAG=false
        test "$HIDEFLAG"   = "true" && hide_group "$arg"   && HIDEFLAG=false
        test "$FINDFLAG"   = "true" && find_wid "$arg"     && FINDFLAG=false
        test "$CLEANFLAG"  = "true" && clean_wid "$arg"    && CLEANFLAG=false
        test "$UNMAPFLAG"  = "true" && unmap_group "$arg"  && UNMAPFLAG=false
        test "$TOGGLEFLAG" = "true" && toggle_group "$arg" && TOGGLEFLAG=false

        case "$arg" in
            -s|--show)   SHOWFLAG=true   ;;
            -h|--hide)   HIDEFLAG=true   ;;
            -f|--find)   FINDFLAG=true   ;;
            -c|--clean)  CLEANFLAG=true  ;;
            -u|--unmap)  UNMAPFLAG=true  ;;
            -t|--toggle) TOGGLEFLAG=true ;;
            -r|--reset)  reset_groups    ;;
            -l|--list)   list_groups     ;;
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
