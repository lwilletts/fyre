#!/bin/mksh
#
# Copyright (c) 2015 Greduan <me@greduan.com>, licensed under the WTFPL
# Adds group-like capabilities, sorta like those you find in CWM and such WMs
# With wildefyr's tweaks to work well with fyre

. ~/.config/fyre/fyrerc

usage() {
    cat << EOF
usage: $(basename $0) [-hCU] [-c wid] [-s wid group] [-tmMu group]
       -h shows this help
       -c cleans WID from group files (and makes it visible)
       -C runs cleanup routine
       -s sets WID's group
       -t toggle group visibility state
       -m maps (shows) group
       -M maps group and unmaps all other groups
       -u unmaps (hides) group
       -U unmaps all the groups
EOF

    exit 1
}

# test for no arguments
test $# -eq 0 && usage

# define our functions

# clean WID ($1) from group files
clean_wid() {
    # TODO: make POSIX compatible, -i is a GNU-ism
    sed -i "/$1/d" $GROUPSDIR/group.*
}

# cleans group ($1) from (in)active files
clean_status() {
    # TODO: make POSIX compatible, -i is a GNU-ism
    sed -i "/$1/d" $GROUPSDIR/active
    sed -i "/$1/d" $GROUPSDIR/inactive
}

# shows all the windows in group ($1)
map_group() {
    # safety
    if ! grep -q $1 < $GROUPSDIR/all; then
        echo "Group doesn't exist"
        exit 1
    fi

    # clean statuses
    clean_status $1
    # add to active
    echo $1 >> $GROUPSDIR/active

    # loop through group and map windows
    while read line; do
        mapw -m $line
    done < $GROUPSDIR/group.$1
}

# hides all the windows in group ($1)
unmap_group() {
    # safety
    if ! grep -q $1 < $GROUPSDIR/all; then
        echo "Group doesn't exist"
        exit 1
    fi

    # clean statuses
    clean_status $1
    # add to inactive
    echo $1 >> $GROUPSDIR/inactive

    # loop through group and unmap windows
    while read line; do
        mapw -u $line
    done < $GROUPSDIR/group.$1
}

# assigns WID ($1) to the group ($2)
set_group() {
    # make sure we've no duplicates
    clean_wid $1
    clean_status $2

    # insert WID into new group if not already there
    grep -q $1 < $GROUPSDIR/group.$2 || \
    echo $1 >> $GROUPSDIR/group.$2

    # if we can't find the group add it to groups and make it active
    grep -q $2 < $GROUPSDIR/all || \
    echo $2 >> $GROUPSDIR/all && \
    echo $2 >> $GROUPSDIR/active

    # map WID if group is active
    grep -q $2 < $GROUPSDIR/active && \
    mapw -m $1

    # unmap WID if group is inactive
    grep -q $2 < $GROUPSDIR/inactive && \
    mapw -u $1
}

# toggles visibility state of all the windows in group ($1)
toggle_group() {
    # safety
    if ! grep -q $1 < $GROUPSDIR/all; then
        echo "Group doesn't exist"
        return
    fi

    # search through active groups first
    grep -q $1 < $GROUPSDIR/active && \
    unmap_group $1 && \
    return

    # search through inactive groups next
    grep -q $1 < $GROUPSDIR/inactive && \
    map_group $1 && \
    return
}

# removes all the unexistent WIDs from groups
# removes all group files that don't exist
# removes from 'all' file all groups that don't exist
cleanup_everything() {
    # clean WIDs that don't exist
    # using `cat` instead of `<` because error suppression
    cat $GROUPSDIR/group.* 2>/dev/null | while read wid; do
        wattr $wid || \
        clean_wid $wid
    done

    # clean group files that are empty
    for file in $GROUPSDIR/group.*; do
        # is the group empty?
        if [ ! -s $file ]; then
            rm -f $file
        fi
    done

    # remove groups that don't exist from 'all'
    while read line; do
        if [ ! -f $GROUPSDIR/group.$line ]; then
            # TODO: make POSIX compatible, -i is a GNU-ism
            sed -i "/$line/d" $GROUPSDIR/all
            clean_status $line
        fi
    done < $GROUPSDIR/all
}

# actual run logic (including arguments and such)

# check $GROUPSDIR exists
test -d $GROUPSDIR || mkdir -p $GROUPSDIR

# touch all the files
test -f $GROUPSDIR/active || :> $GROUPSDIR/active
test -f $GROUPSDIR/inactive || :> $GROUPSDIR/inactive
test -f $GROUPSDIR/all || :> $GROUPSDIR/all

cleanup_everything

# getopts yo
while getopts "hc:Cs:t:m:M:u:U" opt; do
    case $opt in
        h)
            usage
            ;;
        c)
            clean_wid $OPTARG
            mapw -m $OPTARG
            break
            ;;
        C)
            cleanup_everything
            break
            ;;
        s)
            set_group $OPTARG $(eval echo "\$$OPTIND")
            break
            ;;
        t)
            toggle_group $OPTARG
            break
            ;;
        m)
            map_group $OPTARG
            break
            ;;
        M)
            for file in $GROUPSDIR/group.*; do
                group=${file##*.}
                unmap_group $group
            done
            map_group $OPTARG
            break
            ;;
        u)
            unmap_group $OPTARG
            break
            ;;
        U)
            for file in $GROUPSDIR/group.*; do
                group=${file##*.}
                unmap_group $group
            done
            break
            ;;
    esac
done
