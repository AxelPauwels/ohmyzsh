_logoutByUsername() {
  if [ $# -eq 1 ]; then
    launchctl bootout gui/$(id -u ${1})
  else
    msg_error "This function expects exactly 1 parameter. None or too many are given."
  fi
}

# The last custom cursor speed is remembered here so the submenu can keep showing
# it ("Custom choice 3/7") even after another preset was selected in between.
WIZARD_STATE_DIR="${WIZARD_STATE_DIR:-$HOME/.oh-my-zsh/custom/.wizard-state}"
keyrepeat_custom_state="$WIZARD_STATE_DIR/keyrepeat_custom"

# @params: <KeyRepeat> <DelayUntilRepeat>
_keyrepeat_save_custom() {
  mkdir -p "$WIZARD_STATE_DIR"
  printf '%s/%s\n' "${1}" "${2}" >"$keyrepeat_custom_state"
}

_keyrepeat_read_custom() {
  [ -f "$keyrepeat_custom_state" ] && head -n 1 "$keyrepeat_custom_state"
}

_keyrepeat_custom_status() {
  local keyRepeat delayUntilRepeat saved
  keyRepeat=$(defaults read -g KeyRepeat 2>/dev/null)
  delayUntilRepeat=$(defaults read -g InitialKeyRepeat 2>/dev/null)

  # A custom speed that is active right now always wins over the remembered one.
  if [ -n "$keyRepeat" ] && [ "$(get_keyrepeat_name "$keyRepeat" "$delayUntilRepeat")" = "Custom set" ]; then
    msg_dimmed "$keyRepeat/$delayUntilRepeat"
    return 0
  fi

  saved=$(_keyrepeat_read_custom)
  [ -n "$saved" ] && msg_dimmed "$saved"
  return 0
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

# @params: <variable_name> <min> <max> <prompt>
# Keeps asking until a whole number within [min, max] is entered and stores it in
# the given variable.
_prompt_int_in_range() {
  local __target="$1" min="$2" max="$3" prompt="$4" input
  while true; do
    if ! read -r -p "$prompt" input; then
      return 1
    fi
    if [[ "$input" =~ ^[0-9]+$ ]] && [ "$input" -ge "$min" ] && [ "$input" -le "$max" ]; then
      printf -v "$__target" '%s' "$input"
      return 0
    fi
    prompt="Invalid input. Enter a number between $min and $max: "
  done
}

_macKeyrepeat_custom() {
  msg_title "Set custom cursor speed"
  msg_dimmed "Both values are counted in 15ms ticks. System Settings only exposes 2-120"
  msg_dimmed "(key repeat) and 15-120 (delay), but lower values are valid and faster."

  local keyRepeat delayUntilRepeat
  if ! _prompt_int_in_range keyRepeat 1 120 "Custom keyRepeat value (between 1-120): " ||
    ! _prompt_int_in_range delayUntilRepeat 1 120 "Custom delayUntilRepeat value (between 1-120): "; then
    new_line
    msg_warning "No custom cursor speed set."
    return
  fi

  msg_searching "Configuring your choice..."
  _keyrepeat_save_custom "$keyRepeat" "$delayUntilRepeat"
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
_apply_keyrepeat_dev()     { _macKeyrepeat 2 8; }

install_keyrepeat() {
  local menu_title="Which speed you want to set? (keyRepeat/DelayUntilRepeat)"
  local menu_header=""
  local -a menu_labels=(
    "Slow 60/68 (mac default)"
    "Medium 30/34"
    "Fast 1/5"
    "Developer 2/10 (recommended)"
    "Custom choice"
  )
  local -a menu_checks=(
    ""
    ""
    ""
    ""
    "_keyrepeat_custom_status"
  )
  local -a menu_actions=(
    "_apply_keyrepeat_default"
    "_apply_keyrepeat_medium"
    "_apply_keyrepeat_fast"
    "_apply_keyrepeat_dev"
    "_macKeyrepeat_custom"
  )
  local -a menu_sections=()
  local menu_selected
  menu_selected=$(_keyrepeat_current_index)
  run_action_menu
  clear
  menu_action_submenu=1
}

# Index of the currently active speed in install_keyrepeat's menu, so the submenu
# opens on what is configured right now instead of always on the first entry.
_keyrepeat_current_index() {
  local keyRepeat delayUntilRepeat
  keyRepeat=$(defaults read -g KeyRepeat 2>/dev/null)
  delayUntilRepeat=$(defaults read -g InitialKeyRepeat 2>/dev/null)
  if [ -z "$keyRepeat" ]; then
    echo 0
    return
  fi

  case "$(get_keyrepeat_name "$keyRepeat" "$delayUntilRepeat")" in
  'Default Mac') echo 0 ;;
  'Medium') echo 1 ;;
  'Super Fast') echo 2 ;;
  'Developer') echo 3 ;;
  *) echo 4 ;;
  esac
}

check_install_keyrepeat() {
  if defaults read -g KeyRepeat &>/dev/null; then
    keyRepeat=$(defaults read -g KeyRepeat)

    if defaults read -g InitialKeyRepeat &>/dev/null; then
      delayUntilRepeat=$(defaults read -g InitialKeyRepeat)
    fi

    keyrepeatName=$(get_keyrepeat_name "$keyRepeat" "$delayUntilRepeat")

    if [ "$keyrepeatName" = "Default Mac" ]; then
      msg_not_found "Not installed"
    else
      msg_found "Installed '$keyrepeatName' ($keyRepeat/$delayUntilRepeat)"
    fi
  else
    msg_not_found "Not installed"
  fi
}

# --- Trackpad secondary click ------------------------------------------------
# macOS keeps this preference in several places: one domain per trackpad type
# (built-in and Magic Trackpad) plus a few per-host global keys. Writing only one
# of them leaves the others in charge, which is why the setting appears to be
# ignored, so every location is written at once. The values below match exactly
# what System Settings > Trackpad > Point & Click > Secondary click writes.
# @params: <off|two_fingers|bottom_right|bottom_left>
_trackpad_secondary_click_apply() {
  local corner right enabled behavior context
  case "${1}" in
  two_fingers)   corner=0; right=1; enabled=true;  behavior=0; context=1 ;;
  bottom_right)  corner=2; right=0; enabled=false; behavior=1; context=1 ;;
  bottom_left)   corner=1; right=0; enabled=false; behavior=3; context=1 ;;
  *)             corner=0; right=0; enabled=false; behavior=0; context=0 ;;
  esac

  local domain
  for domain in com.apple.AppleMultitouchTrackpad com.apple.driver.AppleBluetoothMultitouch.trackpad; do
    defaults write "$domain" TrackpadCornerSecondaryClick -int "$corner"
    defaults write "$domain" TrackpadRightClick -int "$right"
  done

  defaults -currentHost write -g com.apple.trackpad.enableSecondaryClick -bool "$enabled"
  defaults -currentHost write -g com.apple.trackpad.trackpadCornerClickBehavior -int "$behavior"
  defaults write -g ContextMenuGesture -int "$context"

  _trackpad_activate_settings
}

# System Settings pushes new trackpad preferences to the multitouch driver right
# away. activateSettings does the same for our 'defaults write' calls, so the
# change is live without logging out.
_trackpad_activate_settings() {
  local activate="/System/Library/PrivateFrameworks/SystemAdministration.framework/Resources/activateSettings"
  [ -x "$activate" ] && "$activate" -u >/dev/null 2>&1
  return 0
}

_trackpad_secondary_click_off() {
  _trackpad_secondary_click_apply off
  msg_installed "Trackpad secondary click is now off"
}

_trackpad_secondary_click_two_fingers() {
  _trackpad_secondary_click_apply two_fingers
  msg_installed "Trackpad secondary click is now 'click with two fingers'"
}

_trackpad_secondary_click_bottom_right() {
  _trackpad_secondary_click_apply bottom_right
  msg_installed "Trackpad secondary click is now 'click at bottom right corner'"
}

_trackpad_secondary_click_bottom_left() {
  _trackpad_secondary_click_apply bottom_left
  msg_installed "Trackpad secondary click is now 'click at bottom left corner'"
}

install_trackpad_secondary_click() {
  local menu_title="Which trackpad secondary click do you want?"
  local menu_header=""
  local -a menu_labels=(
    "Off (mac default)"
    "Click with two fingers"
    "Click at bottom right corner (recommended)"
    "Click at bottom left corner"
  )
  local -a menu_checks=()
  local -a menu_actions=(
    "_trackpad_secondary_click_off"
    "_trackpad_secondary_click_two_fingers"
    "_trackpad_secondary_click_bottom_right"
    "_trackpad_secondary_click_bottom_left"
  )
  local -a menu_sections=()
  local menu_selected
  menu_selected=$(_trackpad_secondary_click_current_index)
  run_action_menu
  clear
  menu_action_submenu=1
}

# Index of the currently active option in install_trackpad_secondary_click's menu,
# so the submenu opens on what is configured right now.
_trackpad_secondary_click_current_index() {
  local domain right corner
  for domain in com.apple.AppleMultitouchTrackpad com.apple.driver.AppleBluetoothMultitouch.trackpad; do
    if corner=$(defaults read "$domain" TrackpadCornerSecondaryClick 2>/dev/null); then
      right=$(defaults read "$domain" TrackpadRightClick 2>/dev/null)
      break
    fi
  done

  case "$(get_trackpad_secondary_click_name "$right" "$corner")" in
  'Click with two fingers') echo 1 ;;
  'Click at bottom right corner') echo 2 ;;
  'Click at bottom left corner') echo 3 ;;
  *) echo 0 ;;
  esac
}

# @params: <TrackpadRightClick> <TrackpadCornerSecondaryClick>
get_trackpad_secondary_click_name() {
  case "${1}/${2}" in
  '1/0') echo 'Click with two fingers' ;;
  '0/2') echo 'Click at bottom right corner' ;;
  '0/1') echo 'Click at bottom left corner' ;;
  *) echo 'Off' ;;
  esac
}

check_install_trackpad_secondary_click() {
  local domain right corner name
  for domain in com.apple.AppleMultitouchTrackpad com.apple.driver.AppleBluetoothMultitouch.trackpad; do
    if corner=$(defaults read "$domain" TrackpadCornerSecondaryClick 2>/dev/null); then
      right=$(defaults read "$domain" TrackpadRightClick 2>/dev/null)
      name=$(get_trackpad_secondary_click_name "$right" "$corner")
      if [ "$name" = "Off" ]; then
        msg_not_found "Not installed"
      else
        msg_found "Installed '$name'"
      fi
      return
    fi
  done
  msg_not_found "Not installed"
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
    "Hide hidden files in finder (mac default)"
  )
  local -a menu_checks=()
  local -a menu_actions=(
    "_finder_show_hidden"
    "_finder_hide_hidden"
  )
  local -a menu_sections=()
  local menu_selected
  menu_selected=$(_finder_hidden_current_index)
  run_action_menu
  clear
  menu_action_submenu=1
}

# Index of the currently active option in install_finder_hidden's menu, so the
# submenu opens on what is configured right now.
_finder_hidden_current_index() {
  local value
  value=$(defaults read com.apple.finder AppleShowAllFiles 2>/dev/null)
  case "$(toLower "$value")" in
  1 | true | yes) echo 0 ;;
  *) echo 1 ;;
  esac
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
      msg_not_found "Not installed"
      ;;
    esac
  else
    msg_not_found "Not installed"
  fi
}

# --- Finder default view style -----------------------------------------------
# Sets the default view for new Finder windows via FXPreferredViewStyle. Codes:
#   icnv = Icon view, Nlsv = List view, clmv = Column view, Flwv = Gallery view.

# @params: <four-letter view code>
_finder_view_apply() {
  backup_defaults com.apple.finder FXPreferredViewStyle finder_preferred_view_style
  defaults write com.apple.finder FXPreferredViewStyle -string "${1}"
  killall Finder 2>/dev/null
}

_finder_view_icon()    { _finder_view_apply icnv; msg_installed "Finder default view is now Icon"; }
_finder_view_list()    { _finder_view_apply Nlsv; msg_installed "Finder default view is now List"; }
_finder_view_column()  { _finder_view_apply clmv; msg_installed "Finder default view is now Column"; }
_finder_view_gallery() { _finder_view_apply Flwv; msg_installed "Finder default view is now Gallery"; }

install_finder_view() {
  local menu_title="Which default Finder view do you want?"
  local menu_header=""
  local -a menu_labels=(
    "Icon view (mac default)"
    "List view"
    "Column view (recommended)"
    "Gallery view"
  )
  local -a menu_checks=()
  local -a menu_actions=(
    "_finder_view_icon"
    "_finder_view_list"
    "_finder_view_column"
    "_finder_view_gallery"
  )
  local -a menu_sections=()
  local menu_selected
  menu_selected=$(_finder_view_current_index)
  run_action_menu
  clear
  menu_action_submenu=1
}

# @params: <four-letter view code>
get_finder_view_name() {
  case "${1}" in
  icnv) echo 'Icon' ;;
  Nlsv) echo 'List' ;;
  clmv) echo 'Column' ;;
  Flwv) echo 'Gallery' ;;
  *) echo '' ;;
  esac
}

# Index of the currently active option in install_finder_view's menu, so the
# submenu opens on what is configured right now.
_finder_view_current_index() {
  local value
  value=$(defaults read com.apple.finder FXPreferredViewStyle 2>/dev/null)
  case "$value" in
  icnv) echo 0 ;;
  Nlsv) echo 1 ;;
  clmv) echo 2 ;;
  Flwv) echo 3 ;;
  *) echo 0 ;;
  esac
}

check_install_finder_view() {
  local value name
  value=$(defaults read com.apple.finder FXPreferredViewStyle 2>/dev/null)
  if [ "$value" = "clmv" ]; then
    msg_found "Installed 'Column view'"
  else
    name=$(get_finder_view_name "$value")
    if [ -n "$name" ]; then
      msg_not_found "Not installed (currently '$name view')"
    else
      msg_not_found "Not installed"
    fi
  fi
}
