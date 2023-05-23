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

# manual-installation-check
check_install_iterm() {
  if app_exists iTerm; then
    msg_found "Installed"
  else
    msg_not_found "Not installed"
  fi
}

# manual-installation
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
      import_schema "$ZSH_CUSTOM/schemes/iterm/color-preset/$color_preset_file_name"
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

    msg_searching "Copying existing plist file as backup (~/Library/Preferences/com.googlecode.iterm2.plist.old)"
    cp "$destination_path" "$destination_path.old"
    msg_found "Copied"

    msg_searching "Overriding existing plist file"
    cp "$source_path" "$destination_path"
    msg_found "Overridden"
  else
    msg_warning "No plist file found"

    msg_searching "Creating a new plist file"
    cp "$source_path" "$destination_path"
    msg_found "plist file created"
  fi

  msg_installed "Iterm2 preferences installed"
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

  # use this if script import_schema is NOT used
  # Import the color scheme using the open command in the background
  (open "$color_preset_file_path" &)

  # Wait for a short period to ensure the color scheme is imported
  sleep 1

  # Get the UUID of the imported color scheme
  color_scheme_uuid=$(defaults read com.googlecode.iterm2 "Custom Color Presets" | awk -v scheme="$color_preset_name" -F" = " '$2 == "\""scheme"\"" { print $1 }')

  # Set the imported color scheme as the default
  defaults write com.googlecode.iterm2 "Default Bookmark Guid" -string "$color_scheme_uuid"
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
  _import_scheme
  _set_color_preset
  _set_font
  _override_plist
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
# manual-installation-check
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

# manual-installation-check
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
