#!/bin/sh
#
# wildefyr - 2016 (c) MIT
# translate window classes to binary names and save their position

ARGS="$@"

usage() {
    cat >&2 << EOF
Usage: $(basename $0) [-esod layout] [-S group layout] [-lhq]
    -s | --save:   Save currently visible windows to given layout.
    -S | --group:  Save windows in given group to given layout.
    -o | --open:   Open given layout without affecting currently visable windows.
    -d | --delete: Delete given layout.
    -l | --list:   List all existing layouts.
    -q | --quiet:  Suppress all textual output.
    -h | --help:   Show this help.
EOF

    test "$#" -eq 0 || exit $1
}

layoutCheck() {
    test ! -f $LAYOUTDIR/layout.$LAY && {
        printf '%s\n' "Layout does not exist." >&2
        list_layouts
        exit 1
    }
}

groupCheck() {
    test ! -f "$GROUPSDIR/group.$GROUP" && {
        printf '%s\n' "Group does not exist." >&2
        list_groups
        exit 1
    }
}

save_windows() {
    printf '%s\n' "$lswSort" | while read -r wid; do
        psid=$(process $wid)
        window=$(class $wid)

        # sometimes making the class name lowercase will give the right launch name
        window=$(printf '%s\n' "$window" | tr '[A-Z]' '[a-z]')

        # get arguments program was launched with if appropriate
        case "$window" in
            "wm_class:  not found.")
                continue
                ;;
            "mpv")
                window=$(ps $psid | tail -1 | sed 's/.*mpv/mpv/')
                ;;
            "google-chrome")
                window="google-chrome-stable"
                ;;
        esac

        group=$(windows.sh -f $wid | rev | cut -d'.' -f 1 | rev)
        test -z "$group" && {
            group="N/A"
        }

        XYWH="$(wattr xywh $wid)"

        printf '%s\n' "$XYWH $group $window" >> "$LAYOUTDIR/layout.$LAY"
    done

    printf '%s\n' "Layout $LAY saved."
}

# save currently visible windows to a layout file
save_layout() {
    intCheck $1
    LAY=$1

    test -z "$(lsw)" && {
        printf '%s\n' "No windows are visible to save to layout!"
        exit 1
    }

    # overwrite existing layout
    test -e "$LAYOUTDIR/layout.$LAY" && rm "$LAYOUTDIR/layout.$LAY" 2> /dev/null

    # sort based on x values
    lswSort=$(lsw | xargs wattr xi | sort -n | sed "s/^[0-9]* //")

    save_windows
}

# save windows in given group to a layout file
save_group_layout() {
    test ! -z $3 && usage 1

    GROUP=$(printf "$1" | cut -d\  -f 1)
    LAY=$(printf '%s' "$1" | cut -d\  -f 2)

    test -z "$GROUP" && {
        printf '%s\n\n' "Group cannot be empty." >&2
        listGroups
        usage 1
    } || {
        intCheck "$GROUP"
        groupCheck
    }

    test -z "$LAY" && {
        printf '%s\n\n' "Layout cannot be empty." >&2
        listLayouts
        usage 1
    } || {
        intCheck "$LAY"
    }

    # very unlikely to happen but just to be safe
    test -z "$(cat $GROUPSDIR/group.$GROUP)" && {
        printf '%s\n' "Group file exists but is empty!"
        rm -f "$GROUPSDIR/group.$GROUP"
        exit 1
    }

    # overwrite existing layout
    test -e "$LAYOUTDIR/layout.$LAY" && rm "$LAYOUTDIR/layout.$LAY" 2> /dev/null

    # sort based on x values
    lswSort=$(xargs wattr xi < "$GROUPSDIR/group.$GROUP" | sort -n | \
        sed "s/^[0-9]* //")

    save_windows
}

open_layout() {
    intCheck $1
    LAY=$1
    layoutCheck

    # create lock file for winopen.sh
    :> "$WIDLOCK"

    while read -r window; do
        windowsOpen=$(lsw)
        windowCount=$(printf '%s\n' "$windowsOpen" | wc -w)

        PROGRAM=$(printf '%s\n' "$window" | cut -d\  -f 6-)
        $PROGRAM &

        XYWH=$(printf '%s\n' "$window" | cut -d\  -f -4)
        GROUP=$(printf '%s\n' "$window" | cut -d\  -f 5)

        # wait for window to load...
        while test $windowCount -eq $(lsw | wc -w); do
            sleep 0.1
        done

        # find the wid of the new window
        wid=$(lsw | grep -v "$windowsOpen")
        wtp $XYWH $wid

        focus.sh $wid

        test "$GROUP" != "N/A" && {
            windows.sh -a $wid $GROUP
        }
    done < "$LAYOUTDIR/layout.$LAY"

    # delay deletion just slightly to ensure window isn't moved by winopen.sh
    sleep 0.5
    # clean lock as we have finished opening windows
    rm -f "$WIDLOCK"
}

list_groups() {
    for group in $(find $GROUPSDIR/*.? 2> /dev/null); do
        printf '%s\n' "$(printf '%s' ${group} | rev | cut -d'/' -f 1 | rev):"
        printf '%s\n' "$(cat ${group})"
    done
}

list_layouts() {
    for layout in $(find $LAYOUTDIR/*.? 2> /dev/null); do
        printf '%s\n' "$(printf '%s' ${layout} | rev | cut -d'/' -f 1 | rev):"
        printf '%s\n' "$(cat ${layout})"
    done
}

delete_layout() {
    intCheck $1
    LAY=$1
    layoutCheck

    rm $LAYOUTDIR/layout.$LAY 2> /dev/null
    printf '%s\n' "Layout $LAY deleted."
}

main() {
    . fyrerc.sh

    for arg in "$@"; do
        case $arg in -?|--*) SAVEFLAG=false ;; esac
        test "$SAVEFLAG" = "true" && SAVESTRING="${SAVESTRING}${arg} "
        case $arg in -S|--group) SAVEFLAG=true ;; esac
    done

    test ! -z "$SAVESTRING" && {
        save_group_layout "$SAVESTRING"
        exit 0
    }

    for arg in "$@"; do
        test "$SAVEFLAG"   = "true" && save_layout "$arg"   && exit 0
        test "$OPENFLAG"   = "true" && open_layout "$arg"   && exit 0
        test "$DELETEFLAG" = "true" && delete_layout "$arg" && exit 0

        case "$arg" in
            -s|--save)   SAVEFLAG=true   ;;
            -o|--open)   OPENFLAG=true   ;;
            -d|--delete) DELETEFLAG=true ;;
            -l|--list)   list_layouts    ;;
        esac
    done
}

test "$#" -eq 0 && usage 1

for arg in $ARGS; do
    case "$arg" in
        -q|--quiet)       QUIETFLAG=true ;;
        h|help|-h|--help) usage 0        ;;
    esac
done

test "$QUIETFLAG" = "true" && {
    main $ARGS 2>&1 > /dev/null
} || {
    main $ARGS
}
