#!/bin/sh
#
# wildefyr - 2015 (c) wtfpl
# wrapper for wclass.sh to find any wid's that match a string

usage() { 
    printf '%s\n' "usage: $(basename $0) <type> <string>"
}

if [ -z $1 ] || [ -z $2 ]; then
    usage
fi

case $1 in
    c|class)
        wclass.sh ca | grep $2 | cut -d\  -f 1
        ;;
    m|more)
        wclass.sh ma | grep $2 | cut -d\  -f 1
        ;;
    p|process)
        wclass.sh pa | grep $2 | cut -d\  -f 1
        ;;
    *)
        usage
        ;;
esac

