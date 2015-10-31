#!/bin/mksh
#
# wildefyr - 2015 (c) wtfpl
# check for current windows that are on the screen right now

source ~/.fyrerc

# clean Detect List
if [ -e $DETECT ]; then
    rm $DETECT
fi

for wid in $(lsw); do

    windowC=$(wclass.sh c $wid)
    windowM=$(wclass.sh m $wid)

    if [[ $windowC == "Terminal" ]]; then
        printf '%s\n' $wid >> $DETECT
    fi

    if [[ $windowM == "mpv" ]]; then
        if [ -z $mpvwid ]; then
            printf '%s\n' $wid >> $DETECT
            mpvWid=$wid
        fi
    fi

done

windowsToTile=$(cat $DETECT | wc -l)
