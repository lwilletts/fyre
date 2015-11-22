#!/bin/sh
#
# wildefyr - 2015 (c) wtfpl
# wrapper for wclass.sh to find any wid's that match a string

usage() { 
    printf '%s\n' "usage: $(basename $0) <string>"
}

if [ -z $1 ]; then
    usage
fi

wclass.sh all | grep -i $1 | cut -d\  -f 1 | uniq
