#!/bin/dash
#
# wildefyr - 2015 (c) wtfpl
# check for current windows that are on the screen right now

. ~/.config/fyre/fyrerc

# clean detection lists
if [ -e $WLFILETEMP ]; then
    rm $WLFILE
    rm $WLFILETEMP
fi

if [ -e $MPVFILETEMP ]; then
    rm $MPVFILE
    rm $MPVFILETEMP
fi

for wid in $(lsw); do

    windowC=$(wclass.sh c $wid)
    windowM=$(wclass.sh m $wid)

    if [ $windowC = "Terminal" ]; then
        printf '%s\n' $wid >> $WLFILETEMP
    fi

    if [ $windowM = "mpv" ]; then
        printf '%s\n' $wid >> $MPVFILETEMP
    fi

done

# sort detection lists based on window X values
if [ -e $WLFILETEMP ]; then
    cat $WLFILETEMP | xargs wattr xi | sort -n | sed "s/^[0-9]* //" > $WLFILE
fi

if [ -e $MPVFILETEMP ]; then
    cat $MPVFILETEMP | xargs wattr xi | sort -n | sed "s/^[0-9]* //" > $MPVFILE
fi
