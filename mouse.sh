#!/bin/mksh
#
# wildefyr - 2015 (c) wtfpl
# Enable/Disable mouse based on input

source fyrerc.sh

usage() {
    echo "usage: $(basename $0) <enable|disable>"
    exit 1
}

case $1 in
    e|enable)
        wmp 960 540
        xinput set-int-prop $(xinput | awk '/Mouse/ {printf "%s",$9}' | sed 's/id=//') "Device Enabled" 8 1
        ;;
    d|disable)
        wmp $SW $SH
        xinput set-int-prop $(xinput | awk '/Mouse/ {printf "%s",$9}' | sed 's/id=//') "Device Enabled" 8 0
        ;;
    *)
        usage
        ;;
esac