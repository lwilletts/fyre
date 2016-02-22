#!/bin/sh
#
# wildefyr - 2016 (c) wtfpl
# report group and window title data in lemonbar format

. fyrerc.sh

# colours!!11!!!
ACTIVE="%{F#D7D7D7}"
INACTIVE="%{F#737373}"

# kill me
for group in $GROUPSDIR/group.?; do
    groupCount=$((groupCount + 1))
done

for group in $GROUPSDIR/group.?; do
    groupNum=$(echo "$group" | rev | cut -d'.' -f 1 | rev)

    colour="$INACTIVE"
    for groupId in $(cat "$GROUPSDIR/active"); do
        test "$groupId" -eq "$groupNum" && {
            colour="$ACTIVE"
            break
        } || {
            colour="$INACTIVE"
        }
    done

    title=$(class $(cat $group | head -n 1))
    test "$title" = "URxvt" && {
        title=$(name $(cat $group | head -n 1))
        test "$title" = "urxvt" && {
            title=$(wname $(cat $group | head -n 1))
        }
    }

    stringOut="${stringOut}${colour}\
%{A:wgroups.sh -t ${groupNum}:} #${groupNum} - ${title} %{A}"

    counter=$((counter + 1))
    test "$counter" -ne "$groupCount" && {
        stringOut="${stringOut}${INACTIVE}|"
    }
done

echo "${stringOut}"
