#!/bin/mksh
#
# wildefyr - 2015 (c) wtfpl
# Behavoiur if a window class matches a certain pattern

# I recommend if you want to have these windows in any other position or even
# added to a new group, put it under where it checks it's wid.

source fyrerc.sh

for wid in $(lsw); do

    windowC=$(wclass.sh c $wid)
    windowP=$(wclass.sh p $wid)

    if [[ $windowC == "vdpau" ]]; then
        mpvWid=$wid
    elif [[ $windowC == "xv" ]]; then
        mpvWid=$wid
    elif [[ $windowC == "gl" ]]; then
        mpvWid=$wid
    elif [[ $windowP == *"mpv"* ]]; then
        mpvWid=$wid
    fi

    if [[ $windowP == *"firefox"* ]]; then
        printf '%s\n' $wid >> $DETECT
        firefoxCounter=1

        if [ ! -e $GROUPSDIR/group.2 ]; then
            wgroups.sh -s $wid 2
        fi
    fi

    if [[ $windowC == "mupdf" ]]; then
        printf '%s\n' $wid >> $DETECT
        mupdfCounter=1

        if [ ! -e $GROUPSDIR/group.2 ]; then
            wgroups.sh -s $wid 1
        fi
    fi

    if [[ $windowC == *"ts3"* ]]; then
        printf '%s\n' $wid >> $DETECT
        detectionCounter=$((detectionCounter + 1))

        if [ ! -e $GROUPSDIR/group.3 ]; then
            if [[ $(cat $GROUPSDIR/group.3) != $wid ]]; then
                sed -i 'd' $GROUPSDIR/group.4
                wgroups.sh -s $wid 4
                wgroups.sh -u 4
            fi
        fi
    fi

    if [[ $windowC == "gimp" ]]; then
        printf '%s\n' $wid >> $DETECT
        detectionCounter=$((detectionCounter + 1))
    fi

    if [[ $windowC == "Steam" ]]; then
        printf '%s\n' $wid >> $DETECT
        steamCounter=$((steamCounter + 1))
    fi

    if [[ $windowC == "Battle.net.exe" ]]; then
        printf '%s\n' $wid >> $DETECT
        detectionCounter=$((detectionCounter + 1))
    fi

    if [[ $windowC == "Hearthstone.exe" ]]; then
        printf '%s\n' $wid >> $DETECT
        detectionCounter=$((detectionCounter + 1))
    fi

    if [[ $windowC == "urxvt" ]]; then
        printf '%s\n' $wid >> $DETECT
        urxvtCounter=1
    fi

    if [[ $windowC == "stalonetray" ]]; then
        printf '%s\n' $wid >> $DETECT
        urxvtCounter=$((urxvtCounter + 1))
        X=1000; Y=0; W=100; H=12
        wtp $X $Y $W $H $wid
        source fyrerc.sh
    fi

    if [[ $windowC == *"WM_CLASS"* ]]; then
        printf '%s\n' $wid >> $DETECT
        detectionCounter=$((detectionCounter + 1))
    fi

done

totalDetectList=$((detectionCounter + firefoxCounter + steamCounter + \
                   urxvtCounter + mupdfCounter))
windowsOnscreen=$((windowsOnscreen - totalDetectList))
