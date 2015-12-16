#!/bin/sh
#
# wildefyr - 2015 (c) wtfpl
# store window classes and their positions to reopen later

. ~/.config/fyre/fyrerc

usage() {
    printf '%s\n' "usage: $(basename $0) <save|load|open|replace|list|delete> <layout>"
    exit 1
}

# save all current visible windows to a layout file
saveLayout() {
    LAY=$1
    # clean file for new run
    if [ -e $LAYOUTDIR/layout.$LAY ]; then
        rm $LAYOUTDIR/layout.$LAY 2> /dev/null
    fi

    # sort based on x values
    windowLoop=$(lsw | wc -l)
    lswSort=$(lsw | xargs wattr xi | sort -n | sed "s/^[0-9]* //")

    for i in $(seq $windowLoop); do
        wid=$(printf '%s\n' $lswSort | sed "$i!d")
        XYWH=$(wattr xywh $wid)
        psid=$(wclass.sh p $wid)
        window=$(wclass.sh c $wid)

        if [ "$window" = "URxvt" ]; then
            window=$(ps $psid | tail -1 | perl -p -e 's/^.*?urxvt/urxvt/')
        fi

        if [ "$window" = "mpv" ]; then
            window=$(ps $psid | tail -1 | perl -p -e 's/^.*?mpv/mpv/')
        fi

        printf '%b' "$XYWH $window" >> $LAYOUTDIR/layout.$LAY
        printf '\n' >> $LAYOUTDIR/layout.$LAY
    done
}

# try and position the currently open windows to a layout
loadLayout() {
    LAY=$1
    if [ ! -e $LAYOUTDIR/layout.$LAY ]; then
        printf '%s\n' "Layout does not exist, exiting ..." >&2
        exit 1
    fi

    windowLoop=$(cat $LAYOUTDIR/layout.$LAY | wc -l)
    lswSort=$(lsw | xargs wattr xi | sort -n | sed "s/^[0-9]* //")
    lswCounter=$(echo $lswSort | wc -w)

    for i in $(seq $windowLoop); do
        window=$(sed "$i!d" < $LAYOUTDIR/layout.$LAY | cut -d\  -f 5)

        echo $i $lswCounter
        for j in $(seq $lswCounter); do
            wid=$(printf '%s\n' $lswSort | sed "$j!d")
            windowClass=$(wclass.sh c $wid)

            if [ "$windowClass" = "URxvt" ]; then
                windowClass="urxvt"
            fi

            echo $wid $window $windowClass
            echo
            printf '%s\n' $lswSort

            if [ "$windowClass" = $window ]; then
                # position the window
                XYWH=$(sed "$i!d" < $LAYOUTDIR/layout.$LAY | cut -d\  -f -4)
                wtp $XYWH $wid
                lswCounter=$(($lswCounter - 1))
                break
            fi
        done
    done
}

# load the entire layout regardless of currently open windows
openLayout() {
    LAY=$1
    if [ ! -e $LAYOUTDIR/layout.$LAY ]; then
        printf '%s\n' "Layout does not exist, exiting ..." >&2
        exit 1
    fi

    windowLoop=$(cat $LAYOUTDIR/layout.$LAY | wc -l)
    for i in $(seq $windowLoop); do
        lswOpen=$(lsw | wc -w)

        program=$(sed "$i!d" < $LAYOUTDIR/layout.$LAY | cut -d\  -f 5-)
        $program &

        # wait for window to appear
        while [ $lswOpen -eq $(lsw | wc -w) ]; do
            sleep 0.2
        done

        # assumes that the window has just been focused
        # find another way
        wid=$(lsw | tail -1)

        # position the window
        XYWH=$(sed "$i!d" < $LAYOUTDIR/layout.$LAY | cut -d\  -f -4)
        wtp $XYWH $wid
    done
}

# try and position the currently open windows to a layout
# but also open windows when a wid cannot be found
replaceLayout() {
    LAY=$1
    if [ ! -e $LAYOUTDIR/layout.$LAY ]; then
        printf '%s\n' "Layout does not exist, exiting ..." >&2
        exit 1
    fi

}

listLayout() {
    LAY=$1
    if [ ! -e $LAYOUTDIR/layout.$LAY ]; then
        printf '%s\n' "Layout does not exist, exiting ..." >&2
        exit 1
    fi

    cat $LAYOUTDIR/layout.$LAY
}

deleteLayout() {
    LAY=$1
    if [ ! -e $LAYOUTDIR/layout.$LAY ]; then
        printf '%s\n' "Layout does not exist, exiting ..." >&2
        exit 1
    else
        rm $LAYOUTDIR/layout.$LAY 2> /dev/null
    fi
}

# test arguments
test -z $2 && usage
case $1 in
    s|save) saveLayout $2 ;;
    l|load) loadLayout $2 ;;
    o|open) openLayout $2 ;;
    r|replace) replaceLayout $2 ;;
    ls|list) listLayout $2 ;;
    d|delete) deleteLayout $2 ;;
    *) usage ;;
esac
