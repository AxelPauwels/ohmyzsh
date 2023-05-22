# File: ~/.oh-my-zsh/custom/1B-emoji.zsh
# --------------------------------------



########
# INFO #
########

# See all: https://apps.timwhitlock.info/emoji/tables/unicode (Replace "U+" by "\U". Example: "U+1F601" will be "\U1F601")
# You also can click in terminal > edit > emoji and click an icon:
# first put single quotes. then add a space to it. stand inside the single quotes before the space, then insert a emoji)
#
# See ~/oh-my-zsh/custom/custom_examples/example-emoji.zsh or use the alias zshShowExamples



#############
# VARIABLES #
#############

EMOJI_SMILEY="\U1F601"		#grinning face with smiling eyes
EMOJI_SMILEY_TEARS="\U1F602"	#face with tears of joy
EMOJI_CHECK="\U2714"		#heavy check mark
EMOJI_CHECKBOX="\U2705"		#white heavy check mark
EMOJI_ROCKET="\U1F680"		#rocket
EMOJI_LIGHT_BULB="\U1F4A1"	#electric light bulb
EMOJI_SPEECH_BALLOON="\U1F4AC"	#speech balloon
EMOJI_EXCLAMATION="\U2757"	#heavy exclamation mark symbol
EMOJI_CONSTRUCTION="\U1F6A7"	#construction sign
EMOJI_WARNING="⚠️ "
EMOJI_GEAR="⚙️ "
EMOJI_SPARKLES="\U2728"		#sparkles
EMOJI_HOUSE="\U1F3E0"		#house building
EMOJI_FINISH_FLAG="\U1F3C1"	#chequered flag
EMOJI_BELL="\U1F514"		#bell
EMOJI_FIRE="\U1F525"		#fire
EMOJI_GLOBE="\U1F30D"		#earth globe europe-africa
EMOJI_BEER="\U1F37A"		#beer mug
EMOJI_HOME="\U1F3E0"		#house building
EMOJI_HAND_OK="\U1F44C"		#ok hand sign
EMOJI_HAND_POINT_RIGHT="\U1F449" #white right pointing backhand index
EMOJI_THUMBS_UP="\U1F44D"	#thumbs up sign
EMOJI_THUMBS_DOWN="\U1F44E"	#thumbs down sign
EMOJI_GEM="\U1F48E"		#gem stone
EMOJI_DIAMONT="\U1F539"		#small blue diamond
EMOJI_CRISTAL_BALL="\U1F52E"    #crystal ball
EMOJI_POOP="\U1F4A9"		#pile of poo
EMOJI_KEY="\U1F511"		#key
EMOJI_LOCK="\U1F512"		#lock



#############
# FUNCTIONS #
#############

# @params: <icon-name> (the icon-name without "EMOJI_")
# @options:
# @return: the icon (and the next echo will be on a new line)
# @example: _icon smiley
#
_icon() {
  if [ $# -eq 1 ]; then
    #make parameter $1 uppercase (bash for is needed for usage like: echo ${1^^} and echo ${1,,})
    emojiNameUppercase=$(echo "$1" | tr '[:lower:]' '[:upper:]')
    #concatenate the uppercase emojiName to string "EMOJI_", and save in new var "emoji"
    eval emoji='$'EMOJI_"${emojiNameUppercase}"
    echo -e ${emoji}
  else
    echo "_icon(): This function requires exact 1 parameter. None or multiple are given."  
  fi
}



# End-of-file --------------------------------------------------
#echo -e "\e[38;5;46m\U2714 \e[38;5;250mEmoji \e[0m"
