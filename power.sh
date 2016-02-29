#!/bin/sh
#
# wildefyr - 2016 (c) wtfpl
# power menu for fyre

usage() {
    cat << EOF
Usage: $(basename $0) [-lerp]
    -e | --exit:   Exit fyre.
    -l | --lock:   Lock the session.
    -p | --power:  Poweroff the machine.
    -r | --reboot: Reboot the machine.
EOF

    test $# -eq 0 || exit $1
}

lockfyre() {
    mpvc --stop -q
    test -d /sys/class/backlight/intel_backlight && {
        LIGHT=$(xbacklight -get)
        LIGHT=$(echo "($LIGHT+0.5)/1" | bc)
        xbacklight -set 0 && slock && xbacklight -set $LIGHT
    } || {
        type slock 2>&1 > /dev/null && {
            # xset dpms force suspend
            slock
        } || {
            printf '%s\n' "slock was not found on your \$PATH."
            exit 1
        }
    }
}

exitfyre() {
    layouts.sh -s 0 -q
    pkill xinit
}

restartfyre() {
    layouts.sh -s 0 -q
    sudo reboot 2>/dev/null
    pkill xinit
}

powerfyre() {
    layouts.sh -s 0 -q
    sudo poweroff 2>/dev/null
    pkill xinit
}

case $1 in
    -l|--lock)     lockfyre    ;;
    -e|--exit)     exitfyre    ;;
    -r|--restart)  restartfyre ;;
    -p|--poweroff) powerfyre   ;;
    *)             usage       ;;
esac
