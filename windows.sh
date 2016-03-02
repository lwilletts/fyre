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
    -z | --cycle:  Cycle through windows in the given group.
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
            foundWid=true
        }
    done

    test "$foundWid" = "true" && {
        printf '%s\n' "$wid was found in a group."
        return 1
    } || {
        printf '%s\n' "$wid was not found in any group."
        return 0
    }
}

clean_wid() {
    wid=$1

    # if it exists in group, map it to the screen
    find_wid "$wid" && return 1
    mapw -m "$wid"

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
    groupNum=$1
    intCheck "$groupNum"

    test -f "$GROUPSDIR/group.${groupNum}" && {
        # make the group visible
        show_group "$groupNum"
        # clean group from active file
        buffer=$(sed "s/$groupNum//" < "$GROUPSDIR/active")
        printf '%s\n' "$buffer" | sed '/^\s*$/d' > "$GROUPSDIR/active"
        rm -f $GROUPSDIR/group.${groupNum}
        printf '%s\n' "group ${groupNum} cleaned!"
    } || {
        printf '%s\n' "group ${groupNum} does not exist!" >&2
    }
}

add_to_group() {
    test ! -z $3 && usage 1

    wid=$(printf "$1" | cut -d\  -f 1)
    groupNum=$(printf '%s' "$1" | cut -d\  -f 2)

    fnmatch "0x*" "$wid"
    intCheck "$groupNum"

    # test if window exists in given group already
    find_wid "$wid" 2>&1 > /dev/null || {
        grep -q "$wid" "$GROUPSDIR/group.${groupNum}" 2> /dev/null && {
            printf '%s\n' "$(class $wid) ($wid) already exists in ${groupNum}!"
            return 1
        } || {
            clean_wid "$wid"
        }
    }

    # hide wid if group is curently hidden
    test -f "$GROUPSDIR/inactive" && {
        while read -r inactive; do
            test "$inactive" -eq "$groupNum" && {
                mapw -u "$wid"
                break
            }
        done < $GROUPSDIR/inactive
    }

    # add group to active if group doesn't exist
    test ! -f "$GROUPSDIR/group.${groupNum}" && {
        printf '%s\n' "$groupNum" >> "$GROUPSDIR/active"
    }

    printf '%s\n' "$wid" >> $GROUPSDIR/group.${groupNum}
    printf '%s\n' "$(class $wid) ($wid) added to ${groupNum}!"
}

hide_group() {
    groupNum=$1
    intCheck "$groupNum"

    printf '%s\n' "$groupNum" >> "$GROUPSDIR/inactive"

    buffer=$(cat "$GROUPSDIR/active" | sed "s/$groupNum//")
    printf '%s\n' "$buffer" | sed '/^\s*$/d' > "$GROUPSDIR/active"

    while read -r wid; do
        mapw -u $wid
    done < $GROUPSDIR/group.${groupNum}

    focus.sh "$(lsw | tac)" "disable"

    printf '%s\n' "group ${groupNum} hidden!"
}

show_group() {
    groupNum=$1
    intCheck "$groupNum"

    printf '%s\n' "$groupNum" >> "$GROUPSDIR/active"

    buffer=$(cat "$GROUPSDIR/inactive" | sed "s/$groupNum//")
    printf '%s\n' "$buffer" | sed '/^\s*$/d' > "$GROUPSDIR/inactive"

    while read -r wid; do
        mapw -m $wid
    done < "$GROUPSDIR/group.${groupNum}"

    printf '%s\n' "group ${groupNum} visible!"
}

map_group() {
    groupNum=$1
    intCheck "$groupNum"

    while read -r active; do
        test "$active" -eq "$groupNum" && {
            activeFlag=true
            break
        }
    done < "$GROUPSDIR/active"

    test "$activeFlag" = "true" && {
        while read -r active; do
            test "$active" -ne $groupNum && {
                hide_group "$active"
            }
        done < "$GROUPSDIR/active"
    } || {
        show_group "$groupNum"

        while read -r active; do
            hide_group "$active"
        done < "$GROUPSDIR/active"
    }
}

toggle_group() {
    groupNum=$1
    intCheck "$groupNum"

    # find out if the group is active
    while read -r active; do
        test "$active" -eq "$groupNum" && {
            activeFlag=true
            break
        }
    done < "$GROUPSDIR/active"

    # logic level over 9000
    test "$activeFlag" = "true" && {
        # hide group if there's only one window
        test $(wc -l < "$GROUPSDIR/group.${groupNum}") -eq 1 && {
            wid=$(cat $GROUPSDIR/group.${groupNum})
            test "$(pfw)" = $wid && {
                hide_group "${groupNum}"
                return 0
            } || {
                focus.sh "$wid" "disable"
            }
        }
        # if more than one window, cycle through them
        test $(wc -l < "$GROUPSDIR/group.${groupNum}") -gt 1 && {
            while read -r wid; do
                test "$(pfw)" = $wid && {
                    cycle_group "$groupNum"
                    return 0
                }
            done < "$GROUPSDIR/group.${groupNum}"
        }
    } || {
        show_group "$groupNum"

        # always place windows at the top of the window stack
        while read -r wid; do
            chwso -r "$wid"
            setborder.sh inactive "$wid"
        done < "$GROUPSDIR/group.${groupNum}"

        # focus the top window in the group
        wid=$(head -n 1 < "$GROUPSDIR/group.${groupNum}")
        focus.sh "$wid" "disable"
    }
}

cycle_group() {
    groupNum=$1
    intCheck "$groupNum"

    while read -r active; do
        test "$active" -eq "$groupNum" && {
            activeFlag=true
            break
        }
    done < "$GROUPSDIR/active"

    test "$activeFlag" = "true" && {
        wid=$(sed "0,/^${PFW}$/d" < $GROUPSDIR/group.${groupNum})
        test -z "$wid" && wid=$(head -n 1 < $GROUPSDIR/group.${groupNum})
        focus.sh "$wid" "disable"
    }
}

reset_groups() {
    while read -r groupNum; do
        show_group "$groupNum"
    done < "$GROUPSDIR/inactive"

    rm -f $GROUPSDIR/*
}

list_groups() {
    for group in $(find $GROUPSDIR/*.? 2> /dev/null); do
        printf '%s\n' "$(printf '%s' ${group} | rev | cut -d'/' -f 1 | rev):"
        printf '%s\n' "$(cat ${group})"
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
        test "$MAPFLAG"    = "true" && map_group "$arg"          && exit 0
        test "$SHOWFLAG"   = "true" && show_group "$arg"         && exit 0
        test "$HIDEFLAG"   = "true" && hide_group "$arg"         && exit 0
        test "$CYCLEFLAG"  = "true" && cycle_group "$arg"        && exit 0
        test "$CLEANFLAG"  = "true" && clean_wid "$arg"          && exit 0
        test "$UNMAPFLAG"  = "true" && unmap_group "$arg"        && exit 0
        test "$TOGGLEFLAG" = "true" && toggle_group "$arg"       && exit 0
        test "$FINDFLAG"   = "true" && {
            find_wid "$arg" && exit 0 || exit 1
            FINDFLAG=false
        }

        case "$arg" in
            -m|--map)    MAPFLAG=true    ;;
            -s|--show)   SHOWFLAG=true   ;;
            -h|--hide)   HIDEFLAG=true   ;;
            -f|--find)   FINDFLAG=true   ;;
            -c|--clean)  CLEANFLAG=true  ;;
            -u|--unmap)  UNMAPFLAG=true  ;;
            -z|--cycle)  CYCLEFLAG=true  ;;
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
