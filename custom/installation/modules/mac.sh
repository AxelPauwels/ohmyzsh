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
    backup_defaults -g KeyRepeat keyrepeat_key
    backup_defaults -g InitialKeyRepeat keyrepeat_delay
    defaults write -g KeyRepeat -int "${1}"
    defaults write -g InitialKeyRepeat -int "${2}"

    msg_warning "These settings only take effect after you logout and login. Do you want to logout now? (y/n)"
    local choice
    while true; do
      read -rsn1 userInput
      choice=$(toLower "$userInput")
      if [[ $choice = "y" ]]; then
        msg_installed "Restarting..."
        _logoutByUsername $USER
        break
      elif [[ $choice = "n" ]]; then
        msg_installed "Ok, these settings will take effect next time you login."
        break
      fi
    done
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

_apply_keyrepeat_default() { _macKeyrepeat 60 68; }
_apply_keyrepeat_medium()  { _macKeyrepeat 30 34; }
_apply_keyrepeat_fast()    { _macKeyrepeat 1 5; }
_apply_keyrepeat_dev()     { _macKeyrepeat 2 10; }

install_keyrepeat() {
  local menu_title="Which speed you want to set? (keyRepeat/DelayUntilRepeat)"
  local menu_header=""
  local -a menu_labels=(
    "Default Mac 60/68"
    "Medium 30/34"
    "Fast 1/5"
    "Developer 2/10 (recommended)"
    "Custom choice"
  )
  local -a menu_checks=()
  local -a menu_actions=(
    "_apply_keyrepeat_default"
    "_apply_keyrepeat_medium"
    "_apply_keyrepeat_fast"
    "_apply_keyrepeat_dev"
    "_macKeyrepeat_custom"
  )
  local menu_selected=0
  run_action_menu
  clear
  menu_action_submenu=1
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

# --- Finder hidden files -----------------------------------------------------

_finder_show_hidden() {
  backup_defaults com.apple.finder AppleShowAllFiles finder_show_all_files
  defaults write com.apple.finder AppleShowAllFiles true
  killall Finder
  msg_installed "Hidden files are now shown in Finder"
}

_finder_hide_hidden() {
  backup_defaults com.apple.finder AppleShowAllFiles finder_show_all_files
  defaults write com.apple.finder AppleShowAllFiles false
  killall Finder
  msg_installed "Hidden files are now hidden in Finder"
}

install_finder_hidden() {
  local menu_title="Show or hide hidden files in finder:"
  local menu_header=""
  local -a menu_labels=(
    "Show hidden files in finder"
    "Hide hidden files in finder"
  )
  local -a menu_checks=()
  local -a menu_actions=(
    "_finder_show_hidden"
    "_finder_hide_hidden"
  )
  local menu_selected=0
  run_action_menu
  clear
  menu_action_submenu=1
}

check_install_finder_hidden() {
  if defaults read com.apple.finder AppleShowAllFiles &>/dev/null; then
    local value
    value=$(defaults read com.apple.finder AppleShowAllFiles)
    case "$(toLower "$value")" in
    1 | true | yes)
      msg_found "Installed 'Hidden files shown'"
      ;;
    *)
      msg_found "Installed 'Hidden files hidden'"
      ;;
    esac
  else
    msg_not_found "Not installed"
  fi
}
