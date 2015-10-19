#!/bin/mksh
#
# wildefyr - 2015 (c) wtfpl
# Test window classes when being opened

wid=$1
windowC=$(wclass.sh c $wid)
windowP=$(wclass.sh p $wid)

if [[ $windowC == "mupdf" ]]; then
    wgroups.sh -s $wid 1
elif [[ $windowC == "Navigator" ]]; then
    wgroups.sh -s $wid 2
elif [[ $windowP == *"wildefyr.net"* ]]; then
    position.sh mid $wid
    transset-df -i $wid 0.75
    wgroups.sh -s $wid 3
elif [[ $windowC == *"ts3"* ]]; then
    wgroups.sh -s $wid 4
elif [[ $windowC == "vdpau" ]] || [[ $windowC == "xv" ]] || \ 
    [[ $windowC == "gl" ]] || [[ $windowP == *"mpv"* ]]; then
    tile.sh
    wgroups.sh -s $wid 5
elif [[ $windowP == *"alsamixer"* ]]; then
    position.sh mid $wid
    transset-df -i $wid 0.75
elif [[ $windowC == "urxvt" ]]; then
    position.sh md $wid
    transset-df -i $wid 0.75
elif [[ $windowP == *"urxvtd"* ]]; then
    position.sh tll $wid
    transset-df -i $wid 0.75
else
    position.sh md $wid
fi
