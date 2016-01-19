#!/bin/sh
#
# wildefyr - 2016 (c) wtfpl
# toggle mouse device

ARGS="$@"

usage() {
    printf '%s\n' "Usage: $(basename $0) <enable|disable|toggle>"
    test -z $1 && exit 0 || exit $1
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

moveMouseDisabled() {
    wmp $SW $SH
}

enableMouse() {
    device=$(getMouseDevice)
    xinput set-int-prop $device "Device Enabled" $device 1
}

disableMouse() {
    device=$(getMouseDevice)
    moveMouseDisabled
    xinput set-int-prop $device "Device Enabled" $device 0
}

toggleMouse() {
    device=$(getMouseDevice)
    status=$(getMouseStatus)
    test "$status" -eq 0 && status=1 || status=0
    test "$status" -eq 0 && moveMouseDisabled
    xinput set-int-prop $device "Device Enabled" $device $status
}

main() {
    . fyrerc.sh

    case $1 in
        e|enable)  enableMouse  ;;
        d|disable) disableMouse ;;
        t|toggle)  toggleMouse  ;;
        h|help)    usage        ;;
        *)         usage        ;;
    esac
}

test -z "$ARGS" || main $ARGS
