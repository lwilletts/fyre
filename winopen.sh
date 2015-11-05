#!/bin/mksh
#
# wildefyr - 2015 (c) wtfpl
# test window classes when being opened

wid=$1
windowC=$(wclass.sh c $wid)
windowM=$(wclass.sh m $wid)
windowP=$(wclass.sh p $wid)

if [[ $windowC == "mupdf" ]]; then
    wgroups.sh -s $wid 1
elif [[ $windowC == "Navigator" ]]; then
    sleep 0.1
    wgroups.sh -s $wid 2
elif [[ $windowC == "Dialog" ]]; then
    position.sh md $wid
elif [[ $windowP == *"wildefyr.net"* ]]; then
    position.sh mid $wid
    transset-df -i $wid 0.75
    wgroups.sh -s $wid 3
elif [[ $windowC == *"ts3"* ]]; then
    wgroups.sh -s $wid 4
elif [[ $windowM == "mpv" ]]; then
    wgroups.sh -s $wid 5
    transset-df -i $wid 1
    tile.sh mpv
elif [[ $windowP == *"mpsyt"* ]]; then
    position.sh tr $wid
    position.sh ext $wid
    wgroups.sh -s $wid 6
    transset-df -i $wid 0.75
elif [[ $windowP == *"alsamixer"* ]]; then
    position.sh mid $wid
    transset-df -i $wid 0.75
elif [[ $windowC == "urxvt" ]]; then
    position.sh md $wid
    transset-df -i $wid 0.75
elif [[ $windowP == *"urxvtd"* ]]; then
    tile.sh mpv 
    transset-df -i $wid 0.75
    deletelock.sh lock $wid
else
    position.sh mid $wid
fi
