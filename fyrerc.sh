#!/bin/sh
#
# wildefyr - 2016 (c) wtfpl
# source file for fyre

    # environment files
###############################################################################

FYREDIR=${FYREDIR:-~/.config/fyre}

GROUPSDIR=${GROUPSDIR:-$FYREDIR/groups}
LAYOUTDIR=${LAYOUTDIR:-$FYREDIR/layouts}
test ! -d "$GROUPSDIR" && mkdir -p "$GROUPSDIR"
test ! -d "$LAYOUTDIR" && mkdir -p "$LAYOUTDIR"

SCREENS=${SCREENS:-$FYREDIR/screens}
RESOLUTIONS=${RESOLUTIONS:-$FYREDIR/resolutions}

FSFILE=${FSFILE:-$FYREDIR/fullinfo}

    # window management
###############################################################################

nuScreens=$(wc -l < "$SCREENS")
test "$nuScreens" -eq "1" && {
    ROOT=$(lsw -r)
    SW=$(wattr w $ROOT)
    SH=$(wattr h $ROOT)
} || {
    # probably make a new call to something like screens.sh that does all of this
    test -f $RESOLUTIONS && rm $RESOLUTIONS

    for i in "$(seq $nuScreens)"; do
        sed "$i!d" < $SCREENS | cut -d\  -f 3 | cut -d+ -f 1 | sed "s/x/ /g" \
            >> $RESOLUTIONS
    done
}

PFW=$(pfw)
CUR=${2:-$(pfw)}

BW=${BW:-2}

X=$(wattr x $CUR 2> /dev/null)
Y=$(wattr y $CUR 2> /dev/null)
W=$(wattr w $CUR 2> /dev/null)
H=$(wattr h $CUR 2> /dev/null)

XGAP=${XGAP:-$((20))}
TGAP=${TGAP:-$((40))}
BGAP=${BGAP:-$((20 - BW))}
# add $BW for non-overlapping borders / will probably cause glitches
IGAP=${IGAP:-$((0))}
VGAP=${VGAP:-$((0))}

minW=$((466 - IGAP + BW))
minH=$((252 - VGAP + BW))

ACTIVE=${ACTIVE:-0xD7D7D7}
WARNING=${WARNING:-0xB23450}
INACTIVE=${INACTIVE:-0x737373}

    # other
###############################################################################

BLUR=0
WALL=$(sed '1!d; s_~_/home/wildefyr_' < $(which bgc))
DURATION=60

warn() {
    test "$#" -eq 0 && return 1
    setborder.sh warning $1 && chwso -r $1
}

name() {
    test "$#" -eq 0 && return 1
    for wid in "$@"; do
        case "$wid" in
            0x*)
                lsw -a | grep -q "$wid" && {
                    xprop -id "$wid" WM_CLASS | cut -d\" -f 2
                } || {
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
                    xprop -id "$wid" _NET_WM_PID | cut -d\" -f 4
                } || {
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
        mpvWid=$(xprop -id "$wid" WM_NORMAL_HINTS | sed '5s/[^0-9]*//p;d' | tr / \ )
        printf '%s\n' "$mpvWid"
    } || {
        printf '%s\n' "Please enter a valid mpv window id." >&2
        return
    }
}
