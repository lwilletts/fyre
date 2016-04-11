type fyrerc 2>&1 > /dev/null && {
    . fyrerc

    alias quit="power --exit"
    alias lock="power --lock"
    alias reboot="power --reboot"
    alias poweroff="power --power"
    alias editfyre="$EDITOR $FYREDIR/config"
}
