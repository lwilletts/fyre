#!/bin/sh
#
# wildefyr - 2015 (c) wtfpl
# use slop to get xywh position for urxvt

eval $(slop)
urxvtc -name 'slop'
wtp $X $Y $W $H $(wid.sh "slop" | tail -1)
