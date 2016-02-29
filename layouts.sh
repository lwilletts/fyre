#!/bin/sh
#
# wildefyr - 2016 (c) wtfpl
# store window classes and their positions to reopen later

ARGS="$@"

usage() {
    cat << EOF

Usage: $(basename $0) [-eslord layout] [-S group layout] [-h]
    -L: List existing layouts.
    -e: Echo given layout file.
    -s: Save currently visible windows to given layout.
    -S: Save windows in given group to given layout.
    -l: Load currently open windows into given layout.
    -o: Open given layout without affecting currently visable windows.
    -r: Replace all currently open windows with the given layout.
    -d: Delete given layout.
    -h: Show this help.

Only the first option given is executed.
EOF

    test $# -eq 0 || exit $1
}

intCheck() {
    test $1 -ne 0 2> /dev/null
    test $? -ne 2 || {
         printf '%s\n' "$1 is not an integer." >&2
         echo; usage 1
    }
}

layoutCheck() {
    test ! -f $LAYOUTDIR/layout.$LAY && {
        printf '%s\n' "Layout does not exist." >&2
        listLayouts
        exit 1
    }
}

groupCheck() {
    test ! -f "$GROUPSDIR/group.$GROUP" && {
        printf '%s\n' "Group does not exist." >&2
        listGroups
        exit 1
    }
}

saveWindows() {
    for i in $(seq $windowLoop); do
        wid=$(printf '%s\n' $lswSort | sed "$i!d")

        psid=$(process $wid)
        window=$(class $wid)

        # rename the window classes to their names on $PATH
        # also if appropriate, save arguments it was launched with
        test "$window" = "URxvt" && {
            window=$(ps $psid | tail -1 | perl -p -e 's/^.*?urxvt/urxvt/')
        }
        test "$window" = "mpv" && {
            window=$(ps $psid | tail -1 | perl -p -e 's/^.*?mpv/mpv/')
        }
        test "$window" = "Firefox" && {
            window="firefox"
        }
        test "$window" = "google-chrome" && {
            window="google-chrome-stable"
        }
        test "$window" = "WM_CLASS:  not found." && {
            continue
        }

        XYWH=$(wattr xywh $wid)
        printf '%b' "$XYWH $window" >> $LAYOUTDIR/layout.$LAY
        printf '\n' >> $LAYOUTDIR/layout.$LAY
    done
}

# save currently visible windows to a layout file
saveLayout() {
    intCheck $1
    LAY=$1

    # overwrite existing layout
    test -e $LAYOUTDIR/layout.$LAY && rm $LAYOUTDIR/layout.$LAY 2> /dev/null

    # sort based on x values
    windowLoop=$(lsw | wc -l)
    lswSort=$(lsw | xargs wattr xi | sort -n | sed "s/^[0-9]* //")

    saveWindows

    printf '%s\n' "Layout $LAY saved."
}

# save window id's in group to a layout file
saveGroupLayout() {
    test -z $1 && {
        printf '%s\n\n' "Group cannot be empty." >&2
        listGroups
        usage 1
    } || {
        intCheck $1
        GROUP=$1
        groupCheck
    }

    test -z $2 && {
        printf '%s\n\n' "Layout cannot be empty." >&2
        listLayouts
        usage 1
    } || {
        intCheck $2
        LAY=$2
    }

    # overwrite existing layout
    test -e $LAYOUTDIR/layout.$LAY && rm $LAYOUTDIR/layout.$LAY 2> /dev/null

    # sort based on x values
    windowLoop=$(wc -l < $GROUPSDIR/group.$GROUP )
    lswSort=$(cat $GROUPSDIR/group.$GROUP | xargs wattr xi | sort -n |
sed "s/^[0-9]* //")

    saveWindows

    printf '%s\n' "Layout $LAY saved."
}

# try and position the currently open windows to a layout
loadLayout() {
    intCheck $1
    LAY=$1
    layoutCheck

    windowLoop=$(wc -l < $LAYOUTDIR/layout.$LAY)
    lswSort=$(lsw | xargs wattr xi | sort -n | sed "s/^[0-9]* //")
    lswCounter=$(echo $lswSort | wc -w)

    for i in $(seq $windowLoop); do
        window=$(sed "$i!d" < $LAYOUTDIR/layout.$LAY | cut -d\  -f 5)

        for j in $(seq $lswCounter); do
            wid=$(printf '%s\n' $lswSort | sed "$j!d")
            windowClass=$(class $wid)

            if [ "$windowClass" = "URxvt" ]; then
                windowClass="urxvt"
            fi

            echo $wid $window $windowClass \n

            if [ "$windowClass" = $window ]; then
                # position the window
                # XYWH=$(sed "$i!d" < $LAYOUTDIR/layout.$LAY | cut -d\  -f -4)
                # wtp $XYWH $wid
                lswCounter=$(($lswCounter - 1))
                break
            fi
        done
    done
}

# load the entire layout regardless of currently visible windows
openLayout() {
    intCheck $1
    LAY=$1
    layoutCheck

    windowLoop=$(wc -l < $LAYOUTDIR/layout.$LAY)
    for i in $(seq $windowLoop); do
        lswOpen=$(lsw | wc -w)

        program=$(sed "$i!d" < $LAYOUTDIR/layout.$LAY | cut -d\  -f 5-)
        $program &

        # wait for window to appear - this fking sucks
        while [ $lswOpen -eq $(lsw | wc -w) ]; do
            sleep 0.5
        done

        # assumes that the window has just been focused / not ideal
        wid=$(lsw | tail -1)

        # position the window
        XYWH=$(sed "$i!d" < $LAYOUTDIR/layout.$LAY | cut -d\  -f -4)
        wtp $XYWH $wid
    done
}

# try and position the currently open windows to a layout
# but also open windows when a wid cannot be found
replaceLayout() {
    intCheck $1
    LAY=$1
    layoutCheck
}

listGroups() {
    printf '%s\n' "Existing groups:"
    ls $GROUPSDIR
}

listLayouts() {
    printf '%s\n' "Existing layouts:"
    ls $LAYOUTDIR
}

echoLayout() {
    intCheck $1
    LAY=$1
    layoutCheck

    cat $LAYOUTDIR/layout.$LAY
}

deleteLayout() {
    intCheck $1
    LAY=$1
    layoutCheck

    rm $LAYOUTDIR/layout.$LAY 2> /dev/null
    printf '%s\n' "Layout $LAY deleted."
}

main() {
    . fyrerc.sh

    for arg in "$@"; do
        test "$SAVEFLAG" = "true" && {
            SAVESTRING="$SAVESTRING $arg"
        }

        case $arg in
            -S)        SAVEFLAG=true  ;;
            -?)        break          ;;
            -h|--help) usage 0        ;;
        esac
    done

    test "$SAVEFLAG" = "true" && {
        SAVESTRING=$(echo $SAVESTRING | cut -d\  -f -2)
        saveGroupLayout $SAVESTRING
    }

    while getopts "Le:s:l:o:r:d:Sh" opt; do
        case "$opt" in
            L)  listLayouts           ;;
            e)  echoLayout $OPTARG    ;;
            s)  saveLayout $OPTARG    ;;
            l)  loadLayout $OPTARG    ;;
            o)  openLayout $OPTARG    ;;
            d)  deleteLayout $OPTARG  ;;
            r)  replaceLayout $OPTARG ;;
            S)  usage 1               ;;
            \?) usage 1               ;;
        esac
        exit 0
    done
}

for arg in $ARGS; do
    test "$arg" = "-q" && QUIETFLAG=true
done

test "$QUIETFLAG" = "true" && {
    test -z "$ARGS" || main $ARGS 2>&1 > /dev/null
} || {
    test -z "$ARGS" || main $ARGS
}
