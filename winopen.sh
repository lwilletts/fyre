#!/bin/mksh
#
# wildefyr - 2015 (c) wtfpl
# Test window classes when being opened

wid=$1
windowC=$(wclass.sh c $wid)
windowP=$(wclass.sh p $wid)

if [[ $windowC == "vol" ]]; then
    position.sh md $wid
elif [[ $windowP == *"mosh wildefyr.net"* ]]; then
    position.sh mid $wid
    transset-df -i $wid 0.75
    wgroups.sh -s $wid 3
elif [[ $windowC == "vdpau" ]]; then
    tile.sh
elif [[ $windowC == "xv" ]]; then
    tile.sh
elif [[ $windowC == "gl" ]]; then
    tile.sh
elif [[ $windowC == *"urxvt"* ]]; then
    transset-df -i $wid 0.75
else
    position.sh tll $wid
fi
