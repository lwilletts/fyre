#!/bin/mksh
#
# wildefyr - 2015 (c) wtfpl
# check for current windows that are on the screen right now

source ~/.config/fyre/fyrerc

# clean detection lists
if [ -e $WLFILE ]; then
    rm $WLFILE
fi

if [ -e $MPVFILE ]; then
    rm $MPVFILE
fi

for wid in $(lsw); do

    windowC=$(wclass.sh c $wid)
    windowM=$(wclass.sh m $wid)

    if [[ $windowC == "Terminal" ]]; then
        printf '%s\n' $wid >> $WLFILE
    fi

    if [[ $windowM == "mpv" ]]; then
        printf '%s\n' $wid >> $MPVFILE
    fi

done
