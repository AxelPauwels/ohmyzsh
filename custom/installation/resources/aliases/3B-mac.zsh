# File: ~/.oh-my-zsh/custom/3B-mac.zsh
# ------------------------------------



#########################
# FUNCTIONS FOR ALIASES #
#########################

# @params: <true/false> 
#   - true/false: (bool) when true: the icons will be visible on desktop, when false: the icons will be invisible on desktop 
# @options:
# @return: executes the command to set values that determine to show/hide the icons on desktop
# @example: _macCreateDesktop true
#
_macCreateDesktop() {
  if [ $# -eq 1 ]; then
    if [[ $1 = 'true' || $1 = 'false' ]]; then
      _messageCommand "\$(defaults write com.apple.finder CreateDesktop ${1}) && \$(killall Finder)"
      $(defaults write com.apple.finder CreateDesktop ${1}) && $(killall Finder)    
      if [ $1 = 'true' ]; then
        _messageFinish "Desktop icons are visible."
      else
        _messageFinish "Desktop icons are hidden."
      fi
    else
      _errorMessage "The parameter should be \"true\" or \"false\"."
    fi
  else 
    _errorMessage "This function expects exactly 1 parameter. None or too many are given."
  fi
}

# @params: <true/false>
#   - true/false: (bool) when true: the hidden folders will be visible, when false: the hidden folders will be invisible
# @options:
# @return: executes te command to set values that determine to show all files (including hidden files) or not
# @example: _macShowAllFiles true
#
_macShowAllFiles() {
  if [ $# -eq 1 ]; then
    if [[ $1 = 'true' || $1 = 'false' ]]; then
      _messageCommand "\$(defaults write com.apple.Finder AppleShowAllFiles ${1}) && \$(killall Finder)"
      $(defaults write com.apple.Finder AppleShowAllFiles ${1}) && $(killall Finder)
      if [ $1 = 'true' ]; then
        _messageFinish "Hidden files are visible."
      else
        _messageFinish "Hidden files are hidden."
      fi
    else
      _errorMessage "The parameter should be \"true\" or \"false\"."
    fi
  else
    _errorMessage "This function expects exactly 1 parameter. None or too many are given."
  fi
}

# @params: <KeyRepeat> <DelayUntilRepeat>
#   - KeyRepeat: (int) the value for "Key Repeat" in System Preferences > Keyboard/keyboard > Key Repeat 
#   - DelayUntilRepeat: (int) the value for "Delay Until Repeat" in System Preferences > Keyboard/keyboard > Delay Until Repeat
# @options:
# @return: executes te command to set values for keyRepeat and InitialKeyRepeat
# @example: _macKeyrepeat 1 10
#
_macKeyrepeat() {
  if [ $# -eq 2 ]; then
    _messageCommand "\$(defaults write -g KeyRepeat -int ${1}) && \$(defaults write -g InitialKeyRepeat -int ${2})"
    $(defaults write -g KeyRepeat -int ${1}) && $(defaults write -g InitialKeyRepeat -int ${2})
    _messageWarning "These settings only take effect after you logout and login. Do you want't to logout now? (y/n)"
    read userInput
    #if []
    local choice=$(_toLower $userInput)
    if [[ $choice = "y" || $choice = "yes"  ]]; then
      _messageFinish "Ok, restarting..."
      _logoutByUsername $USER
    elif [[ $choice = "n" || $choice = "no"  ]]; then
      _messageFinish "Ok, these settings will take effect next time you login."
    fi
  else
    _messageError "This function expects exactly 2 parameters. Too few or too many are given." 
  fi
}



###########
# ALIASES #
###########
# show/hide desktop icons
alias macDesktopShow='_macCreateDesktop true'
alias macDesktopHide='_macCreateDesktop false'


# show/hide hidden files
alias macHiddenfilesShow='_macShowAllFiles true'
alias macHiddenfilesHide='_macShowAllFiles false'

# set keyRepeat and keyDelay
alias macKeyrepeatDefault='_macKeyrepeat 60 68' #minimum values that can be set in gui: 2 15
alias macKeyrepeatMedium='_macKeyrepeat 30 34'
alias macKeyrepeatFast='_macKeyrepeat 1 5'
alias macKeyrepeatCustom='_macKeyrepeat 2 10'

# End-of-file --------------------------------------------
#echo "${COLOR_GREEN}${EMOJI_CHECK}${COLOR_GRAY25} Mac${COLOR_RESET}"
