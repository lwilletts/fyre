#bin/sh
#
# wildefyr - 2015 (c) wtfpl
# wrapper for wclass.sh to find any wid's that match a string
# much easier to type

usage() { 
    printf '%s\n' "usage: $(basename $0) <string> (unlisted)"
    exit 1
}

if [ -z $1 ]; then
    usage
fi

case $2 in
    u|-u|unlisted) lswArgs="-u" ;;
    o|-o|override) lswArgs="-o" ;;
    a|-a|all) lswArgs="-a" ;;
esac

wclass.sh all $lswArgs | grep -i $1 | cut -d\  -f 1 | sort | uniq
