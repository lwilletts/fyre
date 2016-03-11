#!/bin/sh
#
# wildefyr - 2016 (c) MIT
# test window classes when being opened

ARGS="$@"

usage() {
    cat << EOF
Usage: $(basename $0) [wid]
EOF

    test $# -eq 0 || exit $1
}

main() {
    . fyrerc.sh

    case $1 in
        0x*) wid=$1  ;;
        *)   usage 0 ;;
    esac

    case "$(name $wid)" in
        "WM_CLASS:  not found.")
            return 1
    esac

    focus.sh $wid

    case "$(name $wid)" in
        "urxvt")
            position.sh res $wid
            snap.sh tl $wid
            ;;
        "mosh")
            position.sh res $wid
            snap.sh tl $wid
            windows.sh -a $wid 3
            ;;
        "tmux")
            position.sh res $wid
            position.sh ext $wid
            snap.sh tl $wid
            windows.sh -a $wid 1
            ;;
        "paste")
            position.sh res $wid
            snap.sh md $wid
            ;;
        "mpsyt")
            position.sh res $wid
            position.sh ext $wid
            snap.sh right $wid
            windows.sh -a $wid 9
            ;;
        "alsamixer")
            position.sh quar $wid
            snap.sh md $wid
            ;;
        "Legions.exe")
            windows.sh -a $wid 6
            ;;
        *)
    case "$(class $wid)" in
        "google-chrome")
            wtp $(($(wattr x $wid) - BW)) $(($(wattr y $wid) - BW)) \
                $(wattr wh $wid) $wid
            windows.sh -a $wid 2
            ;;
        "mpv")
            snap.sh md $wid
            windows.sh -a $wid 5

            test -f "$MPVPOS" && {
                test -z "$(wid.sh mpv)" && {
                    test ! -f "$FSFILE" && {
                        wtp $(cut -d\  -f -4 < $MPVPOS) $wid
                    }
                }
            } || {
                test "$(resolution $wid | cut -d\  -f 1)" -ge $SW && {
                    position.sh full $wid
                }
                test "$(resolution $wid | cut -d\  -f 2)" -ge $SH && {
                    position.sh full $wid
                }
            }
            ;;
        "Steam")
            windows.sh -a $wid 7
            ;;
        "TeamSpeak 3")
            snap.sh md $wid
            windows.sh -a $wid 4
            ;;
        # seriously fuck this program
        "telegram")
            position.sh res $wid
            position.sh ext $wid
            windows.sh -a $wid 4
            ;;
        "MuPDF")
            snap.sh md $wid
            windows.sh -a $wid 6
            ;;
        *)
            snap.sh md $wid
            ;;
    esac
    ;;
    esac
}

main $ARGS
