# File: ~/.oh-my-zsh/custom/1C-colors-and-formats.zsh
# ---------------------------------------------------



########
# info #
########

# colors based on 256 color pallet. Use alias 'zshShowColors' or look for info at '~/.oh-my-zsh/custom/custom_scripts/colors-256.sh'
#
# See ~/oh-my-zsh/custom/custom_examples/example-colors-and-formats.zsh or use the alias zshShowExamples



###########################
# FUNCTIONS FOR VARIABLES #
###########################

# @params: <color-number>
# @options:
# @return: string that can be used in 'echo -e'
# @example: _colorForeground 46
#
_colorForeground() {
  if [ $# -eq 1 ]; then
    echo "\e[38;5;${1}m"
  else
    echo "_colorForeground(): This function requires exact 1 parameter. None or multiple are given."
  fi
}

# @params: <color-number>
# @options:
# @return: string that can be used in 'echo -e'
# @example: _colorBackground 46
#
_colorBackground() {
  if [ $# -eq 1 ]; then
    echo "\e[48;5;${1}m"
  else
    echo "_colorForeground(): This function requires exact 1 parameter. None or multiple are given."
  fi
}

# @params: <format-number>
# @options:
# @return: string that can be used in 'echo -e'
# @example: _textFormat 4
#
_textFormat() {
  if [ $# -eq 1 ]; then
    echo "\e[${1}m"
  else
    echo "_textFormat(): This function requires exact 1 parameter. None or multiple are given."
  fi
}



#############
# VARIABLES #
#############

# @note: These variables must be used in an echo with escape character":  echo -e
# @example: echo -e "${COLOR_GREEN}my green text${FORMAT_RESET}"

COLOR_RESET=$(_textFormat 0)
COLOR_BLACK=$(_colorForeground 232)
COLOR_GRAY75=$(_colorForeground 238)
COLOR_GRAY50=$(_colorForeground 244)
COLOR_GRAY25=$(_colorForeground 250)
COLOR_WHITE=$(_colorForeground 231)
COLOR_RED=$(_colorForeground 196)
COLOR_GREEN=$(_colorForeground 46)
COLOR_BLUE=$(_colorForeground 39)
COLOR_ORANGE=$(_colorForeground 214)
COLOR_PINK=$(_colorForeground 201)
COLOR_PURPLE=$(_colorForeground 129)
COLOR_YELLOW=$(_colorForeground 226)
ALL_COLORS=(
'black'
'gray75'
'gray50'
'gray25'
'white'
'red'
'green'
'blue'
'orange'
'pink'
'purple'
'yellow'
)

BGCOLOR_GREEN=$(_colorBackground 46)

FORMAT_RESET=$(_textFormat 0)
FORMAT_BOLD=$(_textFormat 1)
FORMAT_DIM=$(_textFormat 2)
FORMAT_ITALIC=$(_textFormat 3)			#works only directly in cli
FORMAT_UNDERLINED=$(_textFormat 4)
FORMAT_BLINKED=$(_textFormat 5)			#doesn't work
FORMAT_REVERSED=$(_textFormat 7)
FORMAT_HIDDEN=$(_textFormat 8)                  #doesn't work
FORMAT_STRIKED=$(_textFormat 9)

FORMAT_BOLD_RESET=$(_textFormat 21) 		#doesn't work
FORMAT_DIM_RESET=$(_textFormat 22)
FORMAT_ITALIC=$(_textFormat 23)			#works only directly in cli
FORMAT_UNDERLINED_RESET=$(_textFormat 24)
FORMAT_BLINKED=$(_textFormat 25)		#doesn't work
FORMAT_REVERSED_RESET=$(_textFormat 27)
FORMAT_HIDDEN_RESET=$(_textFormat 28)		#doesn't work
FORMAT_STRIKED_RESET=$(_textFormat 29)

TEXT_MORE_INFO="Use \"-help\" for more information."



#############
# FUNCTIONS #
#############

# -------------------------------------------
# message functions (text with prefixed icon)
# -------------------------------------------

# @params: <message>
# @options:
# @return: colored string, prefixed with an icon
# @example: _messageSuccess "my text with spaces."
#
_messageSuccess() {
  if [ $# -eq 1 ]; then
    echo -e "$(_icon checkbox)${COLOR_GREEN} ${1}${COLOR_RESET}"
  else
    echo "_messageSuccess(): This function requires exact 1 parameter. None or multiple are given."
  fi
}

# @params: <message>
# @options:
# @return: colored string, prefixed with an icon
# @example: _messageWarning "my text with spaces."
#
_messageWarning() {
  if [ $# -eq 1 ]; then
    echo -e "$(_icon warning)${COLOR_YELLOW} ${1}${COLOR_RESET}"
  else
    echo "_messageWarning(): This function requires exact 1 parameter. None or multiple are given."
  fi
}

# @params: <message>
# @options:
# @return: colored string, prefixed with an icon
# @example: _messageError "my text with spaces."
#
_messageError() {
  if [ $# -eq 1 ]; then
    echo -e "$(_icon exclamation)${COLOR_RED} ${1}${COLOR_RESET}"
  else
    echo "_messageError(): This function requires exact 1 parameter. None or multiple are given."
  fi
}

# @params: <message>
# @options:
# @return: colored string, prefixed with an icon
# @example: _messageInfo "my text with spaces."
#
_messageInfo() {
  if [ $# -eq 1 ]; then
    echo -e "$(_icon speech_balloon) ${COLOR_WHITE}${1}${COLOR_RESET}"
  else
    echo "_messageInfo(): This function requires exact 1 parameter. None or multiple are given."
  fi
}

# @params: <message>
# @options:
# @return: colored string, prefixed with an icon
# @example: _messageCommand "my command that is executing now..."
#
_messageCommand() {
  if [ $# -eq 1 ]; then
    echo -e "$(_icon sparkles) ${COLOR_GRAY25}Running ${COLOR_BLUE}${1}${COLOR_RESET}"
  else
    echo "_messageCommand(): This function requires exact 1 parameter. None or multiple are given."
  fi
}

# @params: <message>
# @options:
# @return: colored string, prefixed with an icon. To provide extra info for a command that is running. This style matches "_messageCommand".
# @example: _messageCommandInfo "extra info about the above-running-command line."
#
_messageCommandInfo() {
  if [ $# -eq 1 ]; then
    echo -e "$(_icon sparkles) ${COLOR_GRAY25}${1}${COLOR_RESET}"
  else
    echo "_messageCommandInfo(): This function requires exact 1 parameter. None or multiple are given."
  fi
}

# @params: <message...> (no maximum parameters)
# @options: -title (The paramater after this option will be highlighted, and not intended like the other parameters)
# @return: colored string, prefixed with an icon
# @example: _messageCommandHelp -title "my title that will be highlighted" "My first line of text" "My second text" "My third..."
#
_messageCommandHelp() {
  if [ $# -ne 0 ]; then
    local is_heading=0   
    for parameter in "$@"
    do
      if [ $parameter = "-title" ]; then
        is_heading=1
        echo ""
        continue        
      fi
      if [ $is_heading -eq 1 ]; then
        is_heading=0        
        echo ${COLOR_PINK}$parameter${COLOR_RESET}
      else
        echo "  ${COLOR_PURPLE}$parameter${COLOR_RESET}"
      fi   
    done  
  else
    echo "_messageCommandHelp(): This function requires minimum 1 parameter. None are given."
  fi
}

# @params: <message>
# @options:
# @return: colored string, prefixed with an icon
# @example: _messageFinished "Done !"
#
_messageFinish() {
  if [ $# -eq 1 ]; then
    echo -e "$(_icon finish_flag)${COLOR_GRAY25} ${1}${COLOR_RESET}"
  else
    echo "_messageFinish(): This function requires exact 1 parameter. None or multiple are given."
  fi
}

# --------------
# text functions
# --------------

# @params: <color-name> <message>
# @options: [-help] shows more information about this command
# @return: colored string
# @example: _textColor red "This is my red text"
#
_textColor() {
  if [ $# -eq 0 ]; then
        _messageError "This function expects exactly 2 parameters. None are given. ${TEXT_MORE_INFO}"
  elif [ $# -eq 1 ]; then
    if [ $1 = "-help" ]; then
      _messageCommandHelp -title "Usage" "_textColor <color-name> <message> | [-help]"
      _messageCommandHelp -title "Required parameters" "<color-name> : One of the existing color variables." "<message> : The string that will have the color."
      _messageCommandHelp -title "Optional parameters" "/"
      _messageCommandHelp -title "Options" "-help : Shows more information about this command."
      _messageCommandHelp -title "Current Color variables"      
      for color in "$ALL_COLORS[@]"
      do
        #make variable color uppercase (bash for is needed for usage like: echo ${1^^} and echo ${1,,})
        colorNameUppercase=$(echo "$color" | tr '[:lower:]' '[:upper:]')
        #concatenate colorNameUppercase to string "COLOR_", and save in new var "currentColor"
        eval currentColor='$'COLOR_"${colorNameUppercase}"
        echo -e "  ${currentColor}${color}${COLOR_RESET}"
      done
    else
      _messageError "This function expects exactly 2 parameters. Only 1 is given. ${TEXT_MORE_INFO}"
    fi    
  elif [ $# -eq 2 ]; then
    #make parameter $1 uppercase (bash for is needed for usage like: echo ${1^^} and echo ${1,,})
    colorNameUppercase=$(echo "$1" | tr '[:lower:]' '[:upper:]')
    #concatenate colorNameUppercase to string "COLOR_", and save in new var "color"
    eval color='$'COLOR_"${colorNameUppercase}"
    echo -e "${color}${2}${COLOR_RESET}"
  else
    _messageError "This function expects exactly 2 parameters. Too many are given. ${TEXT_MORE_INFO}"  
  fi
}



# End-of-file ---------------------------------------------------------------
#echo "${COLOR_GREEN}${EMOJI_CHECK}${COLOR_GRAY25} Colors & formats${COLOR_RESET}"

