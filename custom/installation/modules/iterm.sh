#!/usr/bin/env bash

iterm2_plist="$HOME/Library/Preferences/com.googlecode.iterm2.plist"
meslo_font_size=13 #use odd number here
meslo_font_name="MesloLGS-NF-Regular ${meslo_font_size}"

color_preset_name='Custom'
color_preset_file_name="$color_preset_name.itermcolors"
color_preset_file_path="$ZSH_CUSTOM/schemes/$color_preset_file_name"

defaults_color_preset_key="Color Preset"         #just to keep track of it
defaults_color_preset_value="$color_preset_name" #just to keep track of it

# NOW JUST KEEP TRACK WITH THIS:
defaults_is_our_custom_color_and_font="custom_color_and_font_is_set"

install_iterm() {
  new_line
  msg_title "iTerm2"
  msg_searching "Checking iTerm2 installation"

  if
    app_exists iTerm
  then
    msg_found "Found"
  else
    msg_not_found "Not installed"

    msg_searching "Installing iTerm2"
    install_brew
    brew install --cask iterm2
  fi

  msg_installed "iTerm2 installed"
}

check_install_iterm() {
  if app_exists iTerm; then
    msg_found "Installed"
  else
    msg_not_found "Not installed"
  fi
}

install_iterm_manually() {
  install_iterm
}

# copy file from resources to correct destination and use downloaded script to import this
_import_scheme() {
  new_line
  msg_title "Iterm2 color settings"

  msg_searching "Searching for scheme to import"

  if ! import_schema_exists; then
    msg_not_found "Not Found"

    msg_searching "Searching for destination directory"
    if ! dir_exists "$ZSH_CUSTOM/schemes"; then
      msg_not_found "Not Found"

      msg_searching "Creating destination directory"
      mkdir "$ZSH_CUSTOM/schemes/"
      msg_found "Created"
    else
      msg_found "Found"
    fi

    msg_searching "Searching for scheme file"
    if ! file_exists "$ZSH_CUSTOM/schemes/$color_preset_file_name"; then
      msg_not_found "Not Found"

      msg_searching "Copying schemes before importing"
      if ! file_exists "$ZSH_INSTALL/resources/iterm/color-preset/$color_preset_file_name"; then
        msg_not_found "No schemes found to import"
      else
        msg_searching "Copying schemes"
        cp "$ZSH_INSTALL/resources/iterm/color-preset/$color_preset_file_name" "$ZSH_CUSTOM/schemes/"
        msg_found "Copied"
      fi
      msg_searching "Importing schemes"
      ( import_schema "$ZSH_CUSTOM/schemes/iterm/color-preset/$color_preset_file_name" )
      msg_found "Imported"
    else
      msg_found "Found"
    fi

  else
    msg_found "Found"
  fi

  msg_installed "Scheme imported"
}

# Note this also should be installed to use in other shells, because other shells are depending on your main shell settings
# Note there's also a color-preset/x.itermcolors file. this can be used for manual import at iterm > settings > profiles > Colors > Color Presets (at bottom right) > import

_override_plist() {
  defaults write com.googlecode.iterm2 "$defaults_is_our_custom_color_and_font" -bool "true" # evaluates to 1

  source_path="$ZSH_INSTALL/resources/iterm/plist/com.googlecode.iterm2.with-colors-and-font.plist"
  destination_path="$HOME/Library/Preferences/com.googlecode.iterm2.plist"

  new_line
  msg_title "Override Iterm2 preferences"
  msg_searching "Searching plist file"

  if file_exists "$destination_path"; then
    msg_found "Found"

    if cmp -s "$source_path" "$destination_path"; then
      msg_found "Already up-to-date"
    else
      msg_searching "Copying existing plist file as a timestamped backup"
      plist_backup=$(backup_file_datetime "$destination_path")
      msg_found "Backed up to $plist_backup"

      msg_searching "Overriding existing plist file"
      cp "$source_path" "$destination_path"
      msg_found "Overridden"
    fi
  else
    msg_warning "No plist file found"

    msg_searching "Creating a new plist file"
    cp "$source_path" "$destination_path"
    msg_found "plist file created"
  fi

  msg_installed "Iterm2 preferences installed"
}

# Applies three extra iTerm2 preferences that otherwise surface as first-time
# prompts / restrictions in the terminal:
#   1. PreventEscapeSequenceFromClearingHistory = false
#        -> the "A control sequence attempted to clear scrollback history.
#           Allow this in the future?" prompt. Setting the key (to false = do
#           NOT prevent) is exactly what clicking "Always Allow" does, so the
#           prompt never appears and clearing is allowed.
#   2. ClickToSelectCommand = false
#        -> disables "clicking a command selects it" (which restricts Find,
#           Filter and Select All to that command). This is what the
#           announcement's "Click here to disable this feature" link sets.
#           NoSyncUserHasSelectedCommand is also set so the announcement banner
#           is suppressed.
#   3. Unlimited Scrollback = true on every profile (Settings > Profiles >
#      Terminal > "Unlimited scrollback").
#
# Runs AFTER _override_plist so the freshly-copied plist keeps these values.
# The resources plist is also pre-baked with the same values, so a plain copy
# already carries them; these commands make the intent explicit and idempotent.
_set_terminal_preferences() {
  new_line
  msg_title "Iterm2 terminal preferences"
  msg_searching "Applying scrollback & selection preferences"

  # --- Global preferences ---------------------------------------------------
  defaults write com.googlecode.iterm2 PreventEscapeSequenceFromClearingHistory -bool false
  defaults write com.googlecode.iterm2 ClickToSelectCommand -bool false
  defaults write com.googlecode.iterm2 NoSyncUserHasSelectedCommand -bool true

  # --- Per-profile: unlimited scrollback for every bookmark -----------------
  local i=0
  while /usr/libexec/PlistBuddy -c "Print :'New Bookmarks':$i:'Guid'" "$iterm2_plist" >/dev/null 2>&1; do
    if /usr/libexec/PlistBuddy -c "Print :'New Bookmarks':$i:'Unlimited Scrollback'" "$iterm2_plist" >/dev/null 2>&1; then
      /usr/libexec/PlistBuddy -c "Set :'New Bookmarks':$i:'Unlimited Scrollback' true" "$iterm2_plist"
    else
      /usr/libexec/PlistBuddy -c "Add :'New Bookmarks':$i:'Unlimited Scrollback' bool true" "$iterm2_plist"
    fi
    i=$((i + 1))
  done

  msg_installed "Iterm2 terminal preferences set (restart iTerm2 to apply)"
}

#todo: this can only be set/activated by an applescript (this is under construction)
_set_color_preset() {
  msg_searching "Checking color preset"

  color_preset=$(defaults read com.googlecode.iterm2 "$defaults_color_preset_key" 2>/dev/null)

  if [[ "$color_preset" ]]; then
    if [[ "$color_preset" == "$defaults_color_preset_value" ]]; then
      msg_found "Configured"
    else
      defaults write com.googlecode.iterm2 "$defaults_color_preset_key" "$defaults_color_preset_value"
      msg_found "Configured"
    fi
  else
    msg_not_found "Not configured"

    msg_searching "Configuring"
    defaults write com.googlecode.iterm2 "$defaults_color_preset_key" -string "$defaults_color_preset_value"
    msg_found "Configured"
  fi
  msg_installed "Iterm2 color set"

  # NOTE: the color preset is already imported into the plist by import_schema
  # (via PlistBuddy). We deliberately do NOT `open` the .itermcolors file here:
  # doing so asks iTerm to import the very same preset again, which pops up the
  # modal "Add duplicate color preset?" dialog and disrupts the terminal (it
  # steals focus and forces a redraw that corrupts the wizard menu). So skip it.
}

_set_font() {
  new_line
  msg_title "Iterm2 font settings"

  msg_searching "Checking if font setting are configured"

  bookmark_normal_font=$(/usr/libexec/PlistBuddy -c "Print :'New Bookmarks':0:'Normal Font'" "$iterm2_plist" 2>/dev/null)

  if [[ -n "$bookmark_normal_font" ]]; then
    if [[ "$bookmark_normal_font" == "$meslo_font_name" ]]; then
      msg_found "Configured"
    else
      msg_not_found "Not configured"

      msg_searching "Configuring iterm font and fontsize"
      defaults write com.googlecode.iterm2 "Normal Font" -string "$meslo_font_name"
      /usr/libexec/PlistBuddy -c "Set :'New Bookmarks':0:'Normal Font' '$meslo_font_name'" "$iterm2_plist"
      /usr/libexec/PlistBuddy -c "Set :'New Bookmarks':0:'Normal Font Size' $meslo_font_size" "$iterm2_plist"
      msg_found "Configured"
    fi
  else
    msg_searching "Configuring iterm font and fontsize"
    defaults write com.googlecode.iterm2 "Normal Font" -string "$meslo_font_name"
    /usr/libexec/PlistBuddy -c "Add :'New Bookmarks':0:'Normal Font' string '$meslo_font_name'" "$iterm2_plist"
    /usr/libexec/PlistBuddy -c "Add :'New Bookmarks':0:'Normal Font Size' string '$meslo_font_name'" "$iterm2_plist"
    msg_found "Configured"
  fi

  msg_installed "Iterm2 font and size set"
}

install_color_preset_and_font() {
  # Snapshot the pristine iTerm2 state before we touch anything, so it can be
  # fully restored on uninstall (the steps below rewrite the whole plist).
  backup_path "$iterm2_plist" iterm2_plist
  backup_path "$ZSH_CUSTOM/schemes" iterm_schemes

  _import_scheme
  _set_color_preset
  _set_font
  _override_plist
  _set_terminal_preferences
}

install_color_preset_and_font_manually() {
  install_color_preset_and_font
}

check_install_color_preset_and_font() {
  is_our_custom_color_and_font=$(defaults read com.googlecode.iterm2 "$defaults_is_our_custom_color_and_font" 2>/dev/null)

  if [[ "$is_our_custom_color_and_font" ]]; then
    if [[ "$is_our_custom_color_and_font" == 1 ]]; then
      msg_found "Installed"
      return 0
    fi
  fi
  msg_not_found "Not Installed"
}

# OLD FUNCTIONS:
#check_install_color_preset() {
#  color_preset=$(defaults read com.googlecode.iterm2 "$defaults_color_preset_key" 2>/dev/null)
#
#  if [[ "$color_preset" ]]; then
#    if [[ "$color_preset" == "$defaults_color_preset_value" ]]; then
#      msg_found "Installed"
#      return 0
#    fi
#  fi
#  msg_not_found "Not Installed"
#}

#check_set_font() {
#  bookmark_normal_font=$(/usr/libexec/PlistBuddy -c "Print :'New Bookmarks':0:'Normal Font'" "$iterm2_plist" 2>/dev/null)
#  if [[ "$bookmark_normal_font" ]]; then
#    if [[ "$bookmark_normal_font" == "$meslo_font_name" ]]; then
#      msg_found "Installed"
#    else
#      msg_not_found "Not Installed"
#    fi
#  else
#    msg_not_found "Not Installed"
#  fi
#}
