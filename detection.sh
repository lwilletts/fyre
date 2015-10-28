#!/bin/mksh
#
# wildefyr - 2015 (c) wtfpl
# check for current windows that are on the screen right now

source fyrerc.sh

# clean Detect List
if [ -e $DETECT ]; then
    rm $DETECT
fi

# doesn't matter if mulitple as sort | uniq cleans later
if [ -e $FSFILE ]; then
    cat $FSFILE | cut -d\  -f 5 > $DETECT
fi

for wid in $(lsw); do

    windowC=$(wclass.sh c $wid)
    windowP=$(wclass.sh p $wid)
    windowM=$(wclass.sh m $wid)

    if [[ $windowM == "mpv" ]]; then
        printf '%s\n' $wid >> $DETECT
        detectionCounter=$((detectionCounter + 1))
    fi

    if [[ $windowC == "Navigator" ]]; then
        printf '%s\n' $wid >> $DETECT
        firefoxCounter=1

        if [ ! -e $GROUPSDIR/group.2 ]; then
            wgroups.sh -s $wid 2
        fi
    fi

    if [[ $windowC == "mupdf" ]]; then
        printf '%s\n' $wid >> $DETECT
        detectionCounter=$((detectionCounter + 1))
    fi

    if [[ $windowC == *"ts3"* ]]; then
        printf '%s\n' $wid >> $DETECT
        detectionCounter=$((detectionCounter + 1))
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

    if [[ $windowC == "stalonetray" ]]; then
        printf '%s\n' $wid >> $DETECT
        detectionCounter=$((detectionCounter + 1))
        X=1000; Y=0; W=100; H=12
        wtp $X $Y $W $H $wid
        source fyrerc.sh
    fi

    if [[ $windowC == *"WM_CLASS"* ]]; then
        printf '%s\n' $wid >> $DETECT
        detectionCounter=$((detectionCounter + 1))
    fi

    if [[ $windowC == "urxvt" ]]; then
        printf '%s\n' $wid >> $DETECT
        detectionCounter=$((detectionCounter + 1))
    fi

done

totalDetectList=$((detectionCounter + firefoxCounter + steamCounter))
windowsOnscreen=$((windowsOnscreen - totalDetectList))
