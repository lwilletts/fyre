#!/bin/sh
#
# wildefyr - 2016 (c) MIT
# groups script with usablity enchancements

ARGS="$@"

usage() {
    cat >&2 << EOF
Usage: $(basename $0) [-a wid group] [-fc wid] [-shmtTuz group] [-rlhq]
    -a | --add:    Add a wid to a group, or clean it if it already exists in given group.
    -f | --find:   Outputs wid if it was not found in a group.
    -c | --clean:  Clean wid from all groups.
    -h | --hide:   Hide given group.
    -s | --show:   Show given group.
    -m | --map:    Show given group, but hide other active groups.
    -z | --cycle:  Cycle through windows in the given group.
    -t | --toggle: Toggle given group.
    -T | --smart:  Jump to group; if on a group window, hide the group.
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

    # if wid is found in a group, return the group
    for group in $(find $GROUPSDIR/*.? 2> /dev/null); do
        grep -q "$wid" "$group" && {
            printf '%s\n' "$group"
            return 0
        }
    done

    return 1
}

clean_wid() {
    cleanWid=$1

    # if it doesn't exist in a group, exit
    widInGroups=$(find_wid "$cleanWid")
    test -z "$widInGroups" && return 1

    # make sure the wid is mapped to the screen
    mapw -m "$cleanWid"

    # clean the wid from the group, works for the same wid in multiple groups
    for group in $widInGroups; do
        buffer=$(grep -wv "$cleanWid" "$group")
        test -z "$buffer" 2> /dev/null && {
            cleanGroupNum=$(printf '%s\n' "$group" | rev | cut -d'.' -f 1 | rev)
            unmap_group "$cleanGroupNum" 2>&1 > /dev/null
        } || {
            printf '%s\n' "$buffer" > "$group"
        }
    done

    printf '%s\n' "$(class $cleanWid) ($cleanWid) cleaned!"
}

unmap_group() {
    unmapGroupNum=$1
    intCheck "$unmapGroupNum"

    test -f "$GROUPSDIR/group.${unmapGroupNum}" && {
        # make the group visible
        show_group "$unmapGroupNum"

        # clean group from the active file
        buffer=$(grep -wv "$unmapGroupNum" "$GROUPSDIR/active")
        test -z "$buffer" 2> /dev/null && {
            rm -f "$GROUPSDIR/active"
        } || {
            printf '%s\n' "$buffer" > "$GROUPSDIR/active"
        }

        # clean group from the inactive file
        buffer=$(grep -wv "$unmapGroupNum" "$GROUPSDIR/inactive")
        test -z "$buffer" 2> /dev/null && {
            rm -f "$GROUPSDIR/active"
        } || {
            printf '%s\n' "$buffer" > "$GROUPSDIR/inactive"
        }

        rm -f $GROUPSDIR/group.${unmapGroupNum}
        printf '%s\n' "group ${unmapGroupNum} cleaned!"
    } || {
        printf '%s\n' "group ${unmapGroupNum} does not exist!" >&2
    }
}

toggle_wid_group() {
    test ! -z $3 && usage 1

    addWid=$(printf "$1" | cut -d\  -f 1)
    addGroupNum=$(printf '%s' "$1" | cut -d\  -f 2)

    fnmatch "0x*" "$addWid"
    intCheck "$addGroupNum"

    # this is a dummy wid X11 will return when no window is focused
    test "$addWid" = "0x00000001" && {
        printf '%s\n' "Please enter a valid window id." >&2
        return 1
    }

    # get the current group the wid belongs to - if it does
    currentGroup=$(find_wid "$addWid")
    currentGroup=$(printf '%s\n' "$currentGroup" | rev | cut -d'.' -f 1 | rev)

    # return if it already exists in the given group
    test "$addGroupNum" -eq "$currentGroup" && {
        printf '%s\n' "Window id (${addWid}) alrady exists in ${currentGroup}!"
        return 0
    }

    clean_wid "$addWid"

    # hide wid if group is curently hidden
    test -f "$GROUPSDIR/inactive" && {
        while read -r inactive; do
            test "$inactive" -eq "$addGroupNum" && {
                mapw -u "$addWid"
                break
            }
        done < $GROUPSDIR/inactive
    }

    # add group to active if group doesn't exist
    test ! -f "$GROUPSDIR/group.${addGroupNum}" && {
        printf '%s\n' "$addGroupNum" >> "$GROUPSDIR/active"
    }

    # add wid to the group file
    printf '%s\n' "$addWid" >> $GROUPSDIR/group.${addGroupNum}
    printf '%s\n' "$(class $addWid) ($addWid) added to ${addGroupNum}!"
}

hide_group() {
    hideGroupNum=$1
    intCheck "$hideGroupNum"

    # return if group is already inactive
    test -f "$GROUPSDIR/inactive" && {
        grep -qw "$hideGroupNum" "$GROUPSDIR/inactive" && return 1
    }

    # add the group to the inactive file
    printf '%s\n' "$hideGroupNum" >> "$GROUPSDIR/inactive"

    # clean the group from the active file
    test -f "$GROUPSDIR/active" && {
        buffer=$(grep -wv "$hideGroupNum" "$GROUPSDIR/active")
        test ! -z "$buffer" && {
            printf '%s\n' "$buffer" > "$GROUPSDIR/active"
        } || {
            rm -f "$GROUPSDIR/active"
        }
    }

    # hide all windows in group and set the border to inactive just to be safe
    while read -r addWid; do
        mapw -u "$addWid"
        setborder.sh inactive "$addWid"
    done < $GROUPSDIR/group.${hideGroupNum}

    printf '%s\n' "group ${hideGroupNum} hidden!"
}

show_group() {
    showGroupNum=$1
    intCheck "$showGroupNum"

    # return if group is already active
    test -f "$GROUPSDIR/active" && {
        grep -qw "$hideGroupNum" "$GROUPSDIR/active" && return 1
    }

    # add the group to the active file
    printf '%s\n' "$showGroupNum" >> "$GROUPSDIR/active"

    # clean the group from the inactive file
    test -f "$GROUPSDIR/inactive" && {
        buffer=$(grep -wv "$showGroupNum" "$GROUPSDIR/inactive")
        test ! -z "$buffer" && {
            printf '%s\n' "$buffer" > "$GROUPSDIR/inactive"
        } || {
            rm -f "$GROUPSDIR/inactive"
        }
    }

    # show all windows in group and place them at the top of window stack
    while read -r showWid; do
        mapw -m $showWid
        chwso -r $showWid
    done < "$GROUPSDIR/group.${showGroupNum}"

    # focus the top window in the group
    focusWid=$(head -n 1 < "$GROUPSDIR/group.${toggleGroupNum}")
    focus.sh "$focusWid" "disable"

    printf '%s\n' "group ${showGroupNum} visible!"
}

# show given group and hide all others - could be used for workspaces
map_group() {
    mapGroupNum=$1
    intCheck "$mapGroupNum"

    test -f "$GROUPSDIR/active" && {
        # create temp file to store active windows as functions can modify it
        cp "$GROUPSDIR/active" "$GROUPSDIR/.tmpactive"

        test -f "$GROUPSDIR/active" && {
            while read -r active; do
                test "$active" -eq "$mapGroupNum" && {
                    activeFlag=true
                    break
                }
            done < "$GROUPSDIR/active"

            # return user input if the group was NOT already on the screen
            test "$activeFlag" != "true" && {
                show_group "$mapGroupNum"
            } || {
                show_group "$mapGroupNum" > /dev/null
            }
        }

        # hide all other groups listed in the active file
        while read -r active; do
            test "$mapGroupNum" -ne "$active" && {
                hide_group "$active"
            }
        done < "$GROUPSDIR/.tmpactive"

        rm "$GROUPSDIR/.tmpactive"
    } || {
        # we know it's the only group existing and it's inactive
        show_group "$mapGroupNum"
    }
}

# simple group toggle
toggle_group() {
    toggleGroupNum=$1
    intCheck "$toggleGroupNum"

    # find out if the group is active
    while read -r active; do
        test "$active" -eq "$toggleGroupNum" && {
            activeFlag=true
            break
        }
    done < "$GROUPSDIR/active"

    # hide or show group
    test "$activeFlag" = "true" && {
        hide_group "${toggleGroupNum}"
    } || {
        show_group "$toggleGroupNum"
    }
}

smart_toggle_group() {
    toggleGroupNum=$1
    intCheck "$toggleGroupNum"

    # find out if the group is active
    while read -r active; do
        test "$active" -eq "$toggleGroupNum" && {
            activeFlag=true
            break
        }
    done < "$GROUPSDIR/active"

    test "$activeFlag" = "true" && {
        test $(wc -l < "$GROUPSDIR/group.${toggleGroupNum}") -eq 1 && {
            wid=$(cat $GROUPSDIR/group.${toggleGroupNum})
            test "$(pfw)" = $wid && {
                # hide group as we are already on the first window in group
                hide_group "${toggleGroupNum}"
                return 0
            } || {
                # focus first window in group if we are NOT on a window in group
                focus.sh "$wid" "disable"
                return 0
            }
        } || {
            # hide group if we are on a window in group
            hide_group "${toggleGroupNum}"
            return 0
        }
    }

    # show group as we know it has to inactive
    show_group "$toggleGroupNum"
}

cycle_group() {
    cycleGroupNum=$1
    intCheck "$cycleGroupNum"

    while read -r active; do
        test "$active" -eq "$cycleGroupNum" && {
            activeFlag=true
            break
        }
    done < "$GROUPSDIR/active"

    # show group if group is not active
    test "$activeFlag" != "true" && {
        show_group "$cycleGroupNum"
    }

    # focus next window in group or if at the bottom of stack go to first window
    wid=$(sed "0,/^${PFW}$/d" < $GROUPSDIR/group.${cycleGroupNum})
    test -z "$wid" && wid=$(head -n 1 < $GROUPSDIR/group.${cycleGroupNum})
    focus.sh "$wid" "disable"
}

reset_groups() {
    # map all groups to the screen
    while read -r resetGroupNum; do
        test "$resetGroupNum" != "" && show_group "$resetGroupNum"
    done < "$GROUPSDIR/inactive"

    # clean the group directory
    rm -f $GROUPSDIR/*
}

# list all windows in groups in a friendly-ish format
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
        toggle_wid_group "$ADDSTRING" && exit 0
    }

    for arg in "$@"; do
        test "$MAPFLAG"    = "true" && map_group "$arg"          && exit 0
        test "$SHOWFLAG"   = "true" && show_group "$arg"         && exit 0
        test "$HIDEFLAG"   = "true" && hide_group "$arg"         && exit 0
        test "$CYCLEFLAG"  = "true" && cycle_group "$arg"        && exit 0
        test "$CLEANFLAG"  = "true" && clean_wid "$arg"          && exit 0
        test "$UNMAPFLAG"  = "true" && unmap_group "$arg"        && exit 0
        test "$TOGGLEFLAG" = "true" && toggle_group "$arg"       && exit 0
        test "$SMARTFLAG"  = "true" && smart_toggle_group "$arg" && exit 0
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
            -T|--smart)  SMARTFLAG=true  ;;
            -r|--reset)  reset_groups    ;;
            -l|--list)   list_groups     ;;
        esac
    done
}

test "$#" -eq 0 && usage 1

for arg in $ARGS; do
    case $arg in
        -q|--quiet)       QUIETFLAG=true ;;
        h|help|-h|--help) usage 0        ;;
    esac
done

test "$QUIETFLAG" = "true" && {
    main $ARGS 2>&1 > /dev/null
} || {
    main $ARGS
}
