# File: ~/.oh-my-zsh/custom/custom_examples/example-emoji.zsh -----------------------------------------------------------



##################
# EXAMPLE: ICONS #
##################

echo "**************"
echo "EXAMPLE: ICONS"
echo "**************"
echo "Here is a smiley on the SAME line: $(_icon smiley) (by functionCall inside this \"echo\")"
echo "Here is a smiley on the NEXT line (by functionCall inside a next \"echo\"):"
echo "$(_icon smiley)"
echo "Here is also a smiley on the NEXT line (by direct functionsCall, without using \"echo\")[not preferred]:"
_icon smiley
echo ""
echo "*****************"
echo "CURRENT VARIABLES"
echo "*****************"
echo "$(_icon smiley) smiley"
echo "$(_icon smiley_tears) smiley_tears"
echo "$(_icon check) check"
echo "$(_icon checkbox) checkbox"
echo "$(_icon rocket) rocket"
echo "$(_icon light_bulb) light_bulb"
echo "$(_icon speech_balloon) speech_balloon"
echo "$(_icon exclamation) exclamation"
echo "$(_icon warning) warning"
echo "$(_icon gear) gear"
echo "$(_icon sparkles) sparkles"
echo "$(_icon finish_flag) finish_flag"
echo "$(_icon bell) bell"
echo "$(_icon fire) fire"
echo "$(_icon house) house"
echo "$(_icon globe) globe"
echo "$(_icon beer) beer"
echo "$(_icon home) home"
echo "$(_icon hand_ok) hand_ok"
echo "$(_icon hand_point_right) hand_point_right"
echo "$(_icon thumbs_up) thumbs_up"
echo "$(_icon thumbs_down) thumbs_down"
echo "$(_icon diamont) diamont"
echo "$(_icon gem) gem"
echo "$(_icon cristal_ball) cristal_ball"
echo "$(_icon poop) poop"
echo "$(_icon key) key"
echo "$(_icon lock) lock"
