type fyrerc 2>&1 > /dev/null && {
    test ! -z "$DISPLAY" && {
        . fyrerc

        alias quit='power --exit'
        alias lock='power --lock'
        alias reboot='power --reboot'
        alias poweroff='power --power'
    }
}
