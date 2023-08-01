# Variables
plugin_name='custom-mac'
editor='IntelliJ IDEA' # An app could be found by command `ls /Applications` without the `.app` extension
path_to_zsh_custom="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"

# Private Functions (are not meant to be to call directly from CLI, but are more likely used in an alias

# @params: <string>
#   - string: the string that needs to be uppercase
# @options:
# @return: the uppercased string
# @example: _toUpper "My string"
_toUpper(){
  if [ $# -eq 1 ]; then
    local uppercased=$(echo "$1" | tr '[:lower:]' '[:upper:]')
    echo "$uppercased"
  else
    echo "This function expects exactly 1 parameter. None or too many are given."
  fi
}

# @params: <username>
#   - username: the username to logout
# @options:
# @return: executes the function that results in logging out
# @example: _logoutByUsername "john"
_logoutByUsername() {
  if [ $# -eq 1 ]; then
    echo "launchctl bootout gui/$(id -u ${1})"
    launchctl bootout gui/$(id -u ${1})
    echo "Done."
  else
    echo "This function expects exactly 1 parameter. None or too many are given."
  fi
}


# @params: <true/false>
#   - true/false: (bool) when true: the icons will be visible on desktop, when false: the icons will be invisible on desktop
# @options:
# @return: executes the command to set values that determine to show/hide the icons on desktop
# @example: _macCreateDesktop true
_macCreateDesktop() {
  if [ $# -eq 1 ]; then
    if [[ $1 = 'true' || $1 = 'false' ]]; then
      #echo "Running \$(defaults write com.apple.finder CreateDesktop ${1}) && \$(killall Finder)"
      $(defaults write com.apple.finder CreateDesktop ${1}) && $(killall Finder)
      if [ $1 = 'true' ]; then
        echo "Desktop icons are visible."
      else
        echo "Desktop icons are hidden."
      fi
    else
      echo "The parameter should be \"true\" or \"false\"."
    fi
  else
    echo "This function expects exactly 1 parameter. None or too many are given."
  fi
}

# @params: <true/false>
#   - true/false: (bool) when true: the hidden folders will be visible, when false: the hidden folders will be invisible
# @options:
# @return: executes te command to set values that determine to show all files (including hidden files) or not
# @example: _macShowAllFiles true
_macShowAllFiles() {
  if [ $# -eq 1 ]; then
    if [[ $1 = 'true' || $1 = 'false' ]]; then
      #echo "\$(defaults write com.apple.Finder AppleShowAllFiles ${1}) && \$(killall Finder)"
      $(defaults write com.apple.Finder AppleShowAllFiles ${1}) && $(killall Finder)
      if [ $1 = 'true' ]; then
        echo "Hidden files are visible."
      else
        echo "Hidden files are hidden."
      fi
    else
      echo "The parameter should be \"true\" or \"false\"."
    fi
  else
    echo "This function expects exactly 1 parameter. None or too many are given."
  fi
}

# @params: <KeyRepeat> <DelayUntilRepeat>
#   - KeyRepeat: (int) the value for "Key Repeat" in System Preferences > Keyboard/keyboard > Key Repeat
#   - DelayUntilRepeat: (int) the value for "Delay Until Repeat" in System Preferences > Keyboard/keyboard > Delay Until Repeat
# @options:
# @return: executes te command to set values for keyRepeat and InitialKeyRepeat
# @example: _macKeyrepeat 1 10
_macKeyrepeat() {
  if [ $# -eq 2 ]; then
    #echo "\$(defaults write -g KeyRepeat -int ${1}) && \$(defaults write -g InitialKeyRepeat -int ${2})"
    $(defaults write -g KeyRepeat -int ${1}) && $(defaults write -g InitialKeyRepeat -int ${2})
    echo "These settings only take effect after you logout and login. Do you want't to logout now? (y/n)"
    read userInput
    local choice=$(_toLower $userInput)
    if [[ $choice = "y" || $choice = "yes"  ]]; then
      echo "Ok, restarting..."
      _logoutByUsername $USER
    elif [[ $choice = "n" || $choice = "no"  ]]; then
      echo "Ok, these settings will take effect next time you login."
    fi
  else
    echo "This function expects exactly 2 parameters. Too few or too many are given."
  fi
}

_macCheckPort() {
     lsof -i tcp:"$1"
 }

# Aliases (this plugin)
alias zshCdPluginMac="cd ${path_to_zsh_custom}/plugins/${plugin_name}"
alias zshShowPluginMac="cat ${path_to_zsh_custom}/plugins/${plugin_name}/${plugin_name}.plugin.zsh"
alias zshEditPluginMac="open -a \"${editor}\" ${path_to_zsh_custom}/plugins/${plugin_name}/${plugin_name}.plugin.zsh"

# Aliases
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

alias macCheckPort='_macCheckPort'
alias macKillProcess='kill -9 '
