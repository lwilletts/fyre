#!/bin/sh
#
# wildefyr - 2016 (c) MIT
# source file for fyre

    # environment files
###############################################################################

FYREDIR=${FYREDIR:-~/.config/fyre}

GROUPSDIR=${GROUPSDIR:-$FYREDIR/groups}
LAYOUTDIR=${LAYOUTDIR:-$FYREDIR/layouts}
test ! -d "$GROUPSDIR" && mkdir -p "$GROUPSDIR"
test ! -d "$LAYOUTDIR" && mkdir -p "$LAYOUTDIR"

SCREENS=${SCREENS:-$FYREDIR/screens}
FSFILE=${FSFILE:-$FYREDIR/fullinfo}
MPVPOS=${MPVPOS:-$FYREDIR/mpvpos}
IGNORE=${IGNORE:-$FYREDIR/ignored}
HOVER=${HOVER:-$FYREDIR/hover}

    # window management
###############################################################################

ROOT=$(lsw -r)
SW=$(wattr w $ROOT)
SH=$(wattr h $ROOT)

PFW=$(pfw)
CUR=${2:-$(pfw)}

X=$(wattr x $CUR 2> /dev/null)
Y=$(wattr y $CUR 2> /dev/null)
W=$(wattr w $CUR 2> /dev/null)
H=$(wattr h $CUR 2> /dev/null)

BW=${BW:-1}

# add $BW for non-overlapping borders
IGAP=${IGAP:-$((20))}
VGAP=${VGAP:-$((20))}
# must be multiple of two

XGAP=${XGAP:-$((20))}
BGAP=${BGAP:-$((20))}
TGAP=${TGAP:-$((40))}

eSW=$((SW - XGAP - 2*BW))
eSH=$((SH - TGAP - BGAP))

minW=$((eSW/4 - IGAP))
minH=$((eSH/4 - VGAP))

ACTIVE=${ACTIVE:-0xD7D7D7}
WARNING=${WARNING:-0xB23450}
INACTIVE=${INACTIVE:-0x737373}

    # other
###############################################################################

# set to workspaces or groups
WORKFLOW="groups"

WALL=$(sed '1!d; s_~_/home/wildefyr_' < $(which bgc))
DURATION=5
BLUR=2

MOUSE="false"
SLOPPY="true"

name() {
    test "$#" -eq 0 && return 1
    for wid in "$@"; do
        case "$wid" in
            0x*)
                lsw -a | grep -q "$wid" && {
                    xprop -id "$wid" WM_CLASS | cut -d\" -f 2
                } || {
                    printf '%s\n' "wid does not exist!" >&2
                    return 1
                }
                ;;
            *)  printf '%s\n' "Please enter a valid window id." >&2; return 1 ;;
        esac
    done
}

class() {
    test "$#" -eq 0 && return 1
    for wid in "$@"; do
        case "$wid" in
            0x*)
                lsw -a | grep -q "$wid" && {
                    xprop -id "$wid" WM_CLASS | cut -d\" -f 4
                } || {
                    printf '%s\n' "wid does not exist!" >&2
                    return 1
                }
                ;;
            *)  printf '%s\n' "Please enter a valid window id." >&2; return 1 ;;
        esac
    done
}

process() {
    test "$#" -eq 0 && return 1
    for wid in "$@"; do
        case "$wid" in
            0x*)
                lsw -a | grep -q "$wid" && {
                    xprop -id "$wid" _NET_WM_PID | cut -d\  -f 3
                } || {
                    printf '%s\n' "wid does not exist!" >&2
                    return 1
                }
                ;;
            *)  printf '%s\n' "Please enter a valid window id." >&2; return 1 ;;
        esac
    done
}

resolution() {
    case "$1" in
        0x*) wid=$1 ;;
        *)   printf '%s\n' "Please enter a valid window id." >&2; return 1 ;;
    esac

    test "$(class $wid)" = "mpv" && {
        resolution=$(xprop -id "$wid" WM_NORMAL_HINTS | sed '5s/[^0-9]*//p;d' | tr / \ )
        printf '%s\n' "$resolution"
    } || {
        printf '%s\n' "Please enter a valid mpv window id." >&2
        return 1
    }
}

hoverPush() {
    test -f "$HOVER" && {
        while read -r line; do
            wid=$(printf '%s\n' "$line" | cut -d\  -f 1)
            chwso -r $wid
        done < "$HOVER"
    }
}
