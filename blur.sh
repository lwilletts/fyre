#!/bin/sh
#
# wildefyr - 2015 (c) wtfpl
# blur current background

BLUR=20
WALL=$HOME$(cat $(which bgc) | cut -d~ -f 2)

hsetroot -tile $WALL -blur ${1:-$BLUR}
