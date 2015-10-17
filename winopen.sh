#!/bin/mksh
#
# wildefyr - 2015 (c) wtfpl
# Test window classes when being opened

wid=$1
windowC=$(wclass.sh c $wid)
windowP=$(wclass.sh p $wid)

if [[ $windowC == "volume" ]]; then
    position.sh mid $wid
    transset-df -i $wid 0.75
elif [[ $windowP == *"sshserver"* ]]; then
    position.sh mid $wid
    transset-df -i $wid 0.75
    wgroups.sh -s $wid 3
elif [[ $windowC == "urxvt" ]]; then
    position mid $wid
    transset-df -i $wid 0.75
elif [[ $windowC == "urxvtc" ]]; then
    position tll $wid
    transset-df -i $wid 0.75
elif [[ $windowC == "vdpau" ]] || [[ $windowC == "xv" ]] || \ 
    [[ $windowC == "gl" ]] || [[ $windowP == *"mpv"* ]]; then
    tile.sh
    wgroups.sh -s $wid 5
elif [[ $windowP == *"firefox"* ]]; then
    if [ ! -e /tmp/fyre/groups/group.2 ]; then
        wgroups.sh -s $wid 2
    fi
elif [[ $windowC == "mupdf" ]]; then
    wgroups.sh -s $wid 1
elif [[ $windowC == *"ts3"* ]]; then
    wgroups.sh -s $wid 4
else
    position md $wid
fi
