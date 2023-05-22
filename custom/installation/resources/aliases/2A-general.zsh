# File: ~/.oh-my-zsh/custom/2A-general.zsh
# ----------------------------------------



########
# INFO #
########

# Functions to use in the terminal are without underscores.
# Functions with underscores are used by other functions or aliases, in other files (probably higher in the file hierarchy)



#############
# FUNCTIONS #
#############

# @params: <string>
#   - string: the string that needs to be uppercase
# @options:
# @return: the uppercased string
# @example: _toUpper "My string"
#
_toUpper(){
  if [ $# -eq 1 ]; then
    local uppercased=$(echo "$1" | tr '[:lower:]' '[:upper:]')
    echo $uppercased
  else
    _messageError "This function expects exactly 1 parameter. None or too many are given."
  fi
}

# @params: <string> 
#   - string: the string that needs to be lowercase
# @options:
# @return: the lowercased string 
# @example: _toLower "My string"
#
_toLower(){
  if [ $# -eq 1 ]; then 
    local lowercased=$(echo "$1" | tr '[:upper:]' '[:lower:]')
    echo $lowercased
  else
    _messageError "This function expects exactly 1 parameter. None or too many are given."
  fi
}

# @params: <username>
#   - username: the username to logout
# @options:
# @return: executes the function that results in logging out
# @example: _logoutByUsername "john"
#
_logoutByUsername() {
  if [ $# -eq 1 ]; then
    _messageCommand "launchctl bootout gui/$(id -u ${1})"
    launchctl bootout gui/$(id -u ${1})
    _messageFinish "Done."
  else
    _messageError "This function expects exactly 1 parameter. None or too many are given."
  fi
}

# @params: <command> [<cli-parameters...>]
#   - command: used for displaying the command, and executing the command
#   - [cli-parameters] any number of parameters or options given in the cli
# @options:
# @return: displays the command, then executes the command
# @example: _aliasCommand "git status"
#
_aliasCommand() {
  # $* will put all arguments in 1 string with spaces as delimiter
  _messageCommand "${*}" 
  # evaluate all parameters to run this command with all parameters/options
  eval "${@}" 
  _messageFinish "Done "
}

# @params: <command-info> <command> [<cli-parameters...>]
#   - command-info: extra info displayed beneath the running-command-message
#   - command: used for displaying the command, and executing the command
#   - [cli-parameters] any number of parameters or options given in the cli
# @options:
# @return: displays the command, then displays the command-info, then executes the command
# @example: _gitCommand "git status" "This command will run as ... because ..."
#
_aliasCommandWithInfo() {
  #save the 1st parameter
  local message=${1} 
  #remove the 1st parameter
  set -- "${@:2}" 
  # $* will put all arguments in 1 string with spaces as delimiter
  _messageCommand "${*}" 
  _messageCommandInfo "$message"
  # evaluate all parameters to run this command with all parameters/options
  eval "${@}" 
  _messageFinish "Done "
}




# todo
#echo "TODO: add \"-help\" to findAliases in FunctionGeneral (.oh-my-zsh/custom/2A-general.zsh)"
# todo


# @params: <alias-name> (the alias-name you want to find in all aliases)
# @options:
# @return: a cat of all aliases with the parameter highlighted
# @example: findAliases git 
#
findAliases() {
  # check if there is a parameter ($# will be the number of parameters)
  if [ $# -eq 0 ]; then
    _messageError "This function expects 1 parameter. None are given."
    _messageInfo "Usage example: \"findAliases git\""
  elif [ $# -eq 1 ]; then
    _messageCommand "find ~/.oh-my-zsh/custom -type f -maxdepth 1 -name \"*.zsh\" -exec cat {} + | grep ${FORMAT_BOLD}<parameter>${FORMAT_RESET}"
    find ~/.oh-my-zsh/custom -type f -maxdepth 1 -name "*.zsh" -exec cat {} + | grep ${1}
  else
    _messageError "This function expects just 1 parameter. Multiple are given."
    _messageInfo "Usage example: \"findAliases git\""
  fi
}

# todo
#echo "TODO: findFunctions in FunctionGeneral (.oh-my-zsh/custom/2A-general.zsh)"
# todo


findFunctions() {
  echo "TODO ... "
}



# End-of-file --------------------------------------
#echo "${COLOR_GREEN}${EMOJI_CHECK}${COLOR_GRAY25} General${COLOR_RESET}"
