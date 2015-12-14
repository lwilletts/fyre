#!/bin/sh
#
# wildefyr - 2015 (c) wtfpl
# blur current background

. ~/.config/fyre/fyrerc

hsetroot $WALL -blur ${1:-$BLUR}
