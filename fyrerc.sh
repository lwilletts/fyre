#!/bin/sh
#
# wildefyr - 2016 (c) wtfpl
# source file for global variables across the environment

ROOT=$(lsw -r)
SW=$(wattr w $ROOT)
SH=$(wattr h $ROOT)

PFW=$(pfw)
CUR=${2:-$(pfw)}

BW=${BW:-2}

minW=$((466 + BW))
minH=$((252 + BW))

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

ACTIVE=${ACTIVE:-0xD7D7D7}
WARNING=${WARNING:-0xB23450}
INACTIVE=${INACTIVE:-0x737373}

BLUR=0
WALL=$(sed '1!d; s_~_/home/wildefyr_' < $(which bgc))

# how long to wait to repeat loop in runfyre.sh
DURATION=5

FYREDIR=${FYREDIR:-~/.config/fyre}
GROUPSDIR=${GROUPSDIR:-$FYREDIR/groups}
LAYOUTDIR=${LAYOUTDIR:-$FYREDIR/layouts}

test ! -d $GROUPSDIR && mkdir -p $GROUPSDIR
test ! -e $LAYOUTDIR && mkdir -p $LAYOUTDIR

FSFILE=${FSFILE:-$FYREDIR/fullinfo}
MPVPOS=${MPVPOS:-$FYREDIR/mpvposition}

# vim: set ft=sh :
