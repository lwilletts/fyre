#!/bin/mksh
#
# wildefyr - 2015 (c) wtfpl
# test window classes when being opened

wid=$1
windowC=$(wclass.sh c $wid)
windowP=$(wclass.sh p $wid)

if [[ $windowC == "mupdf" ]]; then
    wgroups.sh -s $wid 1
elif [[ $windowP == *"wildefyr.net"* ]]; then
    position.sh mid $wid
    transset-df -i $wid 0.75
    wgroups.sh -s $wid 3
elif [[ $windowC == *"ts3"* ]]; then
    wgroups.sh -s $wid 4
elif [[ $windowC == "vdpau" ]] || [[ $windowC == "xv" ]] || \ 
    [[ $windowC == "gl" ]] || [[ $windowC == "x11" ]]; then
    focus.sh $wid
    position.sh md $wid
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
    position.sh mid $wid
fi
