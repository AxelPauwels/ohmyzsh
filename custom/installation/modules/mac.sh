_logoutByUsername() {
  if [ $# -eq 1 ]; then
    launchctl bootout gui/$(id -u ${1})
  else
    msg_error "This function expects exactly 1 parameter. None or too many are given."
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
    defaults write -g KeyRepeat -int "${1}"
    defaults write -g InitialKeyRepeat -int "${2}"

    msg_warning "These settings only take effect after you logout and login. Do you want to logout now? (y/n)"
    read userInput
    local choice=$(toLower "$userInput")

    if [[ $choice = "y" || $choice = "yes" ]]; then
      msg_installed "Restarting..."
      _logoutByUsername $USER
    elif [[ $choice = "n" || $choice = "no" ]]; then
      msg_installed "Ok, these settings will take effect next time you login."
    fi
  else
    msg_error "This function expects exactly 2 parameters. Too few or too many are given."
  fi
}

_macKeyrepeat_custom() {
  msg_title "Set custom cursor speed"

  read -p "Custom keyRepeat value (between 2-15): " keyRepeat
  while [[ $userInput -lt 2 || $userInput -gt 15 ]]; do
    read -p "Invalid input. Enter a number between 2 and 15: " userInput
  done

  read -p "Custom delayUntilRepeat value (between 15-120): " delayUntilRepeat
  while [[ $userInput -lt 15 || $userInput -gt 120 ]]; do
    read -p "Invalid input. Enter a number between 1 and 120: " userInput
  done

  msg_searching "Configuring your choice..."
  _macKeyrepeat "$keyRepeat" "$delayUntilRepeat"
}

# @params: <KeyRepeat> <DelayUntilRepeat>
get_keyrepeat_name() {
  combined="${1}/${2}"
  case $combined in
  '60/68')
    echo 'Default Mac'
    ;;
  '30/34')
    echo 'Medium'
    ;;
  '1/5')
    echo 'Super Fast'
    ;;
  '2/10')
    echo 'Developer'
    ;;
  *)
    echo 'Custom set'
    ;;
  esac
}

#minimum values that can be set in GUI: 2 15
_speeds_overview() {
  msg "(1) Default Mac 60/68"
  msg "(2) Medium 30/34"
  msg "(3) Fast 1/5"
  msg "(4) Developer 2/10 (recommended)"
  msg "(5) Custom choice"
}

showManualInstallationMessage() {
  msg_title "Which speed you want to set? (keyRepeat/DelayUntilRepeat)"
  _speeds_overview
  msg_dimmed "(q) Quit"
}

install_keyrepeat() {
  while true; do
    showManualInstallationMessage
    read -p "Option: " choice
    new_line
    case $choice in
    1)
      _macKeyrepeat 60 68
      new_line
      ;;
    2)
      _macKeyrepeat 30 34
      new_line
      ;;
    3)
      _macKeyrepeat 1 5
      new_line
      ;;
    4)
      _macKeyrepeat 2 10
      new_line
      ;;
    5)
      _macKeyrepeat_custom
      new_line
      ;;
    q | Q)
      return
      ;;
    *)
      new_line
      msg_italic "Please choose a option (1-5/q)"
      ;;
    esac
  done
}

check_install_keyrepeat() {
  installed_message="todo"

  if defaults read -g KeyRepeat &>/dev/null; then
    keyRepeat=$(defaults read -g KeyRepeat)

    if defaults read -g InitialKeyRepeat &>/dev/null; then
      delayUntilRepeat=$(defaults read -g InitialKeyRepeat)
    fi

    keyrepeatName=$(get_keyrepeat_name "$keyRepeat" "$delayUntilRepeat")

    msg_found "Installed '$keyrepeatName' ($keyRepeat/$delayUntilRepeat)"
  else
    msg_not_found "Not installed"
  fi
}
