#!/usr/bin/env bash

# ANSI escape codes for colors and text modes
export txt_black='\033[0;30m'
export txt_red='\033[0;31m'
export txt_green='\033[0;32m'
export txt_yellow='\033[0;33m'
export txt_blue='\033[0;34m'
export txt_magenta='\033[0;35m'
export txt_cyan='\033[0;36m'
export txt_white='\033[0;37m'

export txt_bold='\033[1m'
export txt_dimmed='\033[2m'
export txt_dimmed_half='\033[2;3m'
export txt_italic='\033[3m'
export txt_underline='\033[4m'
export txt_blink_slow='\033[5m'
export txt_blink_rapid='\033[6m'
export txt_reverse='\033[7m'
export txt_hidden='\033[8m'
export txt_strikethrough='\033[9m'

export txt_reset='\033[0m'

# Unicode icons:
# https://unicode.org/emoji/charts/full-emoji-list.html
# http://xahlee.info/comp/unicode_arrows.html
export icon_check="✔"
export icon_exclamation="⚠"
export icon_times="✘"
export icon_arrow_right="→"

# we only have 8/16 Colors in our 'Custom Color preset for powerline/agnoster'
# 88/256 Colors would be great, but see documentation how to do that:  https://misc.flogisoft.com/bash/tip_colors_and_formatting
