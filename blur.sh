#!/bin/sh
#
# wildefyr - 2015 (c) wtfpl
# blur current background

. ~/.config/fyre/fyrerc

hsetroot -tile $WALL -blur ${1:-$BLUR}
