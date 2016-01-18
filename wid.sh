#bin/sh
#
# wildefyr - 2016 (c) wtfpl
# wrapper for wclass.sh to find any wid's that match a string
# mainly just for interactive use

readonly PROGNAME=$(basename $0)
readonly PROGDIR=$(readlink -m $(dirname $0))
readonly PROGPATH=${PROGPATH:-$PROGDIR/$PROGNAME}
ARGS="$@"

usage() { 
    printf '%s\n' "Usage: $PROGNAME <string> [unlisted]"
    test -z $1 && exit 0 || exit $1
}

main() {
    test -z $1 && usage 1

    # case $2 in
    #     a|-a|all)      lswArgs="-a" ;;
    #     o|-o|override) lswArgs="-o" ;;
    #     u|-u|unlisted) lswArgs="-u" ;;
    # esac

    wclass.sh all "$lswArgs" | grep -i $1 | cut -d\  -f 1 | sort | uniq
}

main $ARGS
