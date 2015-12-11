#!/bin/sh
#
# wildefyr - 2015 (c) wtfpl
# check for current windows that are on the screen right now

. ~/.config/fyre/fyrerc

# clean detection lists
if [ -e $WLFILETEMP ]; then
    rm $WLFILE 2> /dev/null
    rm $WLFILETEMP 2> /dev/null
fi

if [ -e $MPVFILETEMP ]; then
    rm $MPVFILE 2> /dev/null
    rm $MPVFILETEMP 2> /dev/null
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

# don't include fullscreen window in tiling list regardless of class
if [ -e $FSFILE ]; then
    fullWid=$(cat $FSFILE | cut -d\  -f 5) 
fi

if [ -e $WLFILETEMP ]; then
    for i in $(cat $WLFILETEMP | wc -l); do
        wid=$(cat $WLFILETEMP | sed "$i!d")
        if [ "$wid" = $fullWid ]; then
            sed -i "/$fullWid/d" $WLFILETEMP
        fi
    done
fi

if [ -e $MPVFILETEMP ]; then
    for i in $(cat $MPVFILETEMP | wc -l); do
        wid=$(cat $MPVFILETEMP | sed "$i!d")
        if [ "$wid" = $fullWid ]; then
            sed -i "/$fullWid/d" $MPVFILETEMP
        fi
    done
fi

# sort detection lists based on window X values
if [ -e $WLFILETEMP ]; then
    cat $WLFILETEMP | xargs wattr xi | sort -n | sed "s/^[0-9]* //" > $WLFILE
fi

if [ -e $MPVFILETEMP ]; then
    cat $MPVFILETEMP | xargs wattr xi | sort -n | sed "s/^[0-9]* //" > $MPVFILE
fi
