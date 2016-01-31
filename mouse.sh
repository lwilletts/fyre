#!/bin/sh
#
# wildefyr - 2016 (c) wtfpl
# toggle mouse device

ARGS="$@"

usage() {
    printf '%s\n' "Usage: $(basename $0) <enable|disable|toggle>"
    test -z $1 || exit $1
}

getMouseDevice() {
    device=$(xinput | awk '/Mouse/ {printf "%s\n",$9}' | cut -d= -f 2)

    printf '%s\n' $device
}

getMouseStatus() {
    device=$(getMouseDevice)
    status=$(xinput list-props $device | awk '/Device Enabled/ {printf "%s\n", $NF}')

    printf '%s\n' $status
}

# move mouse to the middle of the given window
moveMouseEnabled() {
    wid=$1
    wmp -a $(($(wattr x $wid) + ($(wattr w $wid) - 100 ))) \
           $(($(wattr y $wid) + ($(wattr h $wid) - 100 )))
}

# move mouse to bottom-right corner of the screen
# TODO: find way of fully hiding the mouse completely
moveMouseDisabled() {
    wmp $SW $SH
}

enableMouse() {
    device=$(getMouseDevice)
    xinput set-int-prop $device "Device Enabled" $device 1
    moveMouseEnabled $PFW 
}

disableMouse() {
    device=$(getMouseDevice)
    moveMouseDisabled
    xinput set-int-prop $device "Device Enabled" $device 0
}

toggleMouse() {
    device=$(getMouseDevice)
    status=$(getMouseStatus)
    test "$status" -eq 1 && status=0 || status=1
    test "$status" -eq 1 && moveMouseEnabled $PFW || moveMouseDisabled
    xinput set-int-prop $device "Device Enabled" $device $status
}

main() {
    . fyrerc.sh

    case $1 in
        e|enable)  enableMouse  ;;
        d|disable) disableMouse ;;
        t|toggle)  toggleMouse  ;;
        *)         usage 0      ;;
    esac
}

test -z "$ARGS" || main $ARGS
