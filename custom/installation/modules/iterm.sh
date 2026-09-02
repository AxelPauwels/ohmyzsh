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
  msg_searching "Applying scrollback, selection & bell preferences"

  # Apply straight to the plist FILE now. This is enough when iTerm2 is NOT
  # running (e.g. the wizard is launched from Terminal.app or a fresh install).
  _apply_iterm_terminal_prefs "$iterm2_plist"

  # Drop cfprefsd's cached copy so it reloads the file we just edited.
  killall cfprefsd 2>/dev/null

  # The hard part: iTerm2 rewrites its ENTIRE plist from its in-memory copy when
  # it quits, so anything we (or `defaults write`) change while it runs is
  # reverted on quit -- which is why "quit & reopen" still showed the old value.
  # To make it stick we re-apply the settings AFTER iTerm2 has fully quit, from
  # a detached watcher that outlives this wizard (and the iTerm2 window hosting
  # it). When the user quits iTerm2, the watcher writes the plist while nothing
  # owns it, so the next launch loads our values cleanly.
  if pgrep -x iTerm2 >/dev/null 2>&1; then
    _persist_iterm_prefs_after_quit
    msg_warning "iTerm2 is running. The settings are queued to apply the moment you quit it."
    msg_installed "Now fully quit iTerm2 (Cmd+Q) and reopen it -- the preferences will be applied."
  else
    msg_installed "Iterm2 terminal preferences set (open iTerm2 to see them)"
  fi
}

# _apply_iterm_terminal_prefs <plist_path>
# Writes every terminal preference we manage directly into the plist FILE:
#   - global selection / scrollback-clearing keys
#   - per-profile Unlimited Scrollback + Silence Bell (mute the audible bell)
_apply_iterm_terminal_prefs() {
  local plist="$1"

  # --- Global preferences ---------------------------------------------------
  _plist_set_bool "$plist" "PreventEscapeSequenceFromClearingHistory" false
  _plist_set_bool "$plist" "ClickToSelectCommand" false
  _plist_set_bool "$plist" "NoSyncUserHasSelectedCommand" true

  # --- Per-profile settings for every bookmark ------------------------------
  local i=0
  while /usr/libexec/PlistBuddy -c "Print :'New Bookmarks':$i:'Guid'" "$plist" >/dev/null 2>&1; do
    _plist_set_profile_bool "$plist" "$i" "Unlimited Scrollback" true
    _plist_set_profile_bool "$plist" "$i" "Silence Bell" true
    i=$((i + 1))
  done
}

# Spawns a detached background process that waits for iTerm2 to exit and then
# writes our preferences to the plist, so iTerm2's on-quit save cannot clobber
# them. Self-terminates after a timeout if iTerm2 never quits.
_persist_iterm_prefs_after_quit() {
  local watcher="$WIZARD_BACKUP_DIR/iterm-prefs-watcher.sh"
  mkdir -p "$WIZARD_BACKUP_DIR"

  cat >"$watcher" <<WATCHER
#!/usr/bin/env bash
plist="$iterm2_plist"

set_bool() {
  if /usr/libexec/PlistBuddy -c "Print :\$2" "\$1" >/dev/null 2>&1; then
    /usr/libexec/PlistBuddy -c "Set :\$2 \$3" "\$1"
  else
    /usr/libexec/PlistBuddy -c "Add :\$2 bool \$3" "\$1"
  fi
}
set_profile_bool() {
  if /usr/libexec/PlistBuddy -c "Print :'New Bookmarks':\$2:'\$3'" "\$1" >/dev/null 2>&1; then
    /usr/libexec/PlistBuddy -c "Set :'New Bookmarks':\$2:'\$3' \$4" "\$1"
  else
    /usr/libexec/PlistBuddy -c "Add :'New Bookmarks':\$2:'\$3' bool \$4" "\$1"
  fi
}

# Wait until no iTerm2 process is running (max ~30 min), then apply.
tries=0
while pgrep -x iTerm2 >/dev/null 2>&1; do
  sleep 2
  tries=\$((tries + 1))
  [ "\$tries" -gt 900 ] && exit 0
done
# Small grace period so iTerm2 finishes writing its own plist first.
sleep 1

set_bool "\$plist" "PreventEscapeSequenceFromClearingHistory" false
set_bool "\$plist" "ClickToSelectCommand" false
set_bool "\$plist" "NoSyncUserHasSelectedCommand" true

i=0
while /usr/libexec/PlistBuddy -c "Print :'New Bookmarks':\$i:'Guid'" "\$plist" >/dev/null 2>&1; do
  set_profile_bool "\$plist" "\$i" "Unlimited Scrollback" true
  set_profile_bool "\$plist" "\$i" "Silence Bell" true
  i=\$((i + 1))
done

killall cfprefsd 2>/dev/null
rm -f "$watcher"
WATCHER

  chmod +x "$watcher"
  nohup bash "$watcher" </dev/null >/dev/null 2>&1 &
  disown 2>/dev/null || true
}

# _plist_set_bool <plist_path> <key> <true|false>
# Sets a top-level boolean key directly in the plist file (adds it if missing),
# avoiding cfprefsd so it stays consistent with the direct file copy above.
_plist_set_bool() {
  local plist="$1" key="$2" value="$3"
  if /usr/libexec/PlistBuddy -c "Print :$key" "$plist" >/dev/null 2>&1; then
    /usr/libexec/PlistBuddy -c "Set :$key $value" "$plist"
  else
    /usr/libexec/PlistBuddy -c "Add :$key bool $value" "$plist"
  fi
}

# _plist_set_profile_bool <plist_path> <bookmark_index> <key> <true|false>
_plist_set_profile_bool() {
  local plist="$1" idx="$2" key="$3" value="$4"
  if /usr/libexec/PlistBuddy -c "Print :'New Bookmarks':$idx:'$key'" "$plist" >/dev/null 2>&1; then
    /usr/libexec/PlistBuddy -c "Set :'New Bookmarks':$idx:'$key' $value" "$plist"
  else
    /usr/libexec/PlistBuddy -c "Add :'New Bookmarks':$idx:'$key' bool $value" "$plist"
  fi
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
