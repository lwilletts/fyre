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

X=$(wattr x $CUR)
Y=$(wattr y $CUR)
W=$(wattr w $CUR)
H=$(wattr h $CUR)

XGAP=${XGAP:-$((20))}
TGAP=${TGAP:-$((40))}
BGAP=${BGAP:-$((20))}
# add $BW for non-overlapping borders / will probably cause glitches
IGAP=${IGAP:-$((0))}
VGAP=${VGAP:-$((0))}

ACTIVE=${ACTIVE:-0xD7D7D7}
WARNING=${WARNING:-0xB23450}
INACTIVE=${INACTIVE:-0x737373}

BLUR=0
WALL=$(cat $(which bgc) | head -n 1 | sed 's#~#/home/wildefyr#')

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
