#!/bin/sh
#
# wildefyr - 2016 (c) MIT
# report group and window title data in lemonbar format

. fyrerc.sh

# colours!!11!!!
ACTIVE="%{F#D7D7D7}"
INACTIVE="%{F#737373}"

for group in $GROUPSDIR/group.?; do
    title=""
    numGroups=$(ls $GROUPSDIR/group.? | wc -l)
    groupNum=$(printf "$group" | rev | cut -d'.' -f 1 | rev)

    colour="$INACTIVE"
    for groupId in $(cat "$GROUPSDIR/active"); do
        test "$groupId" -eq "$groupNum" && {
            colour="$ACTIVE"
            break
        } || {
            colour="$INACTIVE"
        }
    done

    wids=$(cat $group | tr '\n' ' ')

    for wid in $wids; do
        window="$(class ${wid})"

        test "$window" = "URxvt" && {
            window="$(name ${wid})"
            test "$window" = "urxvt" && {
                window="$(wname ${wid})"
            }
            test "$window" = "tmux" && {
                window="$(wname ${wid})"
            }
            test "$window" = "mosh" && {
                window="mosh: $(ps $(process $wid) | tail -1 | awk '{printf $NF}')"
            }
        }
        test "$window" = "mpv" && {
            window="$(wname ${wid}) - $(resolution ${wid} | cut -d\  -f 2)p"
        }
        test "$window" = "Wine" && {
            window="$(wname ${wid})"
        }

        window=$(printf '%s' "$window" | sed '
        s_google-chrome_chrome_
        ')

        test -z "$title" && {
            title="$(printf "$window" | tr '\n' ' ')"
        } || {
            title="${title} \ $(printf "$window" | tr '\n' ' ')"
        }
    done

    test ! -z "$title" && {
        stringOut="${stringOut}${colour}\
%{A:windows.sh -t $groupNum:}  #${groupNum} %{A}-\
%{A:windows.sh -T $groupNum:} ${title}  %{A}"
    } || {
        continue
    }

    counter=$((counter + 1))
    test "$counter" -ne "$numGroups" && {
        stringOut="${stringOut}${INACTIVE}|"
    }
done

echo "${stringOut}"
