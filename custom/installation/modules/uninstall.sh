#!/usr/bin/env bash

# Uninstallers for everything the wizard can install.
#
# Strategy:
#   - If the installer took a pristine snapshot (has_backup <key>), restore it
#     so the file/dir/defaults value is exactly as it was before installing.
#   - Otherwise fall back to the installer's own ".old" backup when one exists.
#   - Otherwise just remove what the installer added.
#
# The status checks below reuse the existing check_install_* functions where
# possible so the menu shows the same "Installed / Not installed" markers.

# ----- Uninstall everything ------------------------------------------------
# Runs every uninstaller except Zsh (skipped for now). Only the items shown in
# the uninstall menu are covered.
uninstall_all() {
  new_line
  msg_title "Uninstall all"

  uninstall_fonts
  uninstall_color_preset_and_font
  uninstall_terminal_font
  uninstall_theme_pk10
  uninstall_prompt_pk10
  uninstall_theme_agnoster
  uninstall_zshrc
  uninstall_keyrepeat
  uninstall_trackpad_secondary_click
  uninstall_finder_hidden
  uninstall_github_cli
  uninstall_gitmoji
  uninstall_tree_command

  menu_action_submenu=0
  # Many items changed, so ask the menu to recompute every status line.
  menu_refresh_all=1
  new_line
  msg_installed "Uninstall all finished"
}

# ----- Zsh -----------------------------------------------------------------
uninstall_zsh() {
  msg_title "Uninstall Zsh"
  msg_warning "Zsh is provided by macOS and is not installed by this wizard."
  msg_found "Nothing to uninstall"
}

# ----- Fonts ---------------------------------------------------------------
uninstall_fonts() {
  msg_title "Uninstall Fonts"
  local fonts_dir="$HOME/Library/Fonts"
  local removed=0
  local src base

  for src in "$ZSH_INSTALL/resources/fonts/MesloLGS/"*; do
    [ -e "$src" ] || continue
    base="$(basename "$src")"
    if [ -f "$fonts_dir/$base" ]; then
      rm -f "$fonts_dir/$base"
      removed=$((removed + 1))
    fi
  done

  while IFS= read -r -d '' src; do
    base="$(basename "$src")"
    if [ -f "$fonts_dir/$base" ]; then
      rm -f "$fonts_dir/$base"
      removed=$((removed + 1))
    fi
  done < <(find "$ZSH_INSTALL/resources/fonts/Powerline" \( -name '*.ttf' -o -name '*.otf' -o -name '*.pcf.gz' \) -type f -print0)

  msg_installed "Removed $removed font file(s)"
}

# ----- Terminal font settings ----------------------------------------------
uninstall_terminal_font() {
  msg_title "Uninstall Terminal font settings"

  if has_backup terminal_plist; then
    restore_path "$terminal_plist" terminal_plist
    killall cfprefsd 2>/dev/null
    msg_installed "Restored original Terminal preferences (restart Terminal)"
  else
    msg_warning "No Terminal preferences backup found; nothing to restore"
  fi
}

# ----- iTerm color & font settings -----------------------------------------
uninstall_color_preset_and_font() {
  msg_title "Uninstall iTerm color & font settings"

  local plist_backup
  plist_backup="$(latest_datetime_backup "$iterm2_plist")"
  if has_backup iterm2_plist; then
    restore_path "$iterm2_plist" iterm2_plist
    msg_found "Restored original iTerm2 preferences"
  elif [ -n "$plist_backup" ]; then
    cp "$plist_backup" "$iterm2_plist"
    msg_found "Restored iTerm2 preferences from $plist_backup"
  elif [ -f "$iterm2_plist.old" ]; then
    cp "$iterm2_plist.old" "$iterm2_plist"
    msg_found "Restored iTerm2 preferences from legacy .old backup"
  else
    msg_warning "No plist backup found; removing our custom defaults only"
  fi

  # Always drop our custom defaults keys so the status flips immediately even
  # if cfprefsd still has the plist cached.
  defaults delete com.googlecode.iterm2 "$defaults_is_our_custom_color_and_font" 2>/dev/null
  defaults delete com.googlecode.iterm2 "$defaults_color_preset_key" 2>/dev/null

  # Remove the imported color scheme directory we created.
  restore_path "$ZSH_CUSTOM/schemes" iterm_schemes

  # Timestamped backups are intentionally kept so no file is ever lost.
  killall cfprefsd 2>/dev/null

  msg_installed "iTerm color & font settings uninstalled (restart iTerm2)"
}

# Removes ~/.p10k.zsh together with every ~/.p10k.zsh.backup* file the wizard
# (or the user) ever created. Shared by the Theme and Prompt uninstallers.
remove_p10k_configs() {
  rm -f "$HOME/.p10k.zsh" "$HOME/.p10k.zsh".backup*
  # Drop any pristine snapshot the installer kept so status flips cleanly.
  rm -rf "$WIZARD_BACKUP_DIR/p10k_config.state" \
    "$WIZARD_BACKUP_DIR/p10k_config.file" \
    "$WIZARD_BACKUP_DIR/p10k_config.dir"
}

# ----- Theme Powerlevel10k -------------------------------------------------
uninstall_theme_pk10() {
  msg_title "Uninstall Theme Powerlevel10k"
  local theme_dir="$HOME/.oh-my-zsh/custom/themes/powerlevel10k"

  if has_backup p10k_theme; then
    restore_path "$theme_dir" p10k_theme
  else
    rm -rf "$theme_dir"
  fi

  remove_p10k_configs

  msg_installed "Theme Powerlevel10k uninstalled"
}

# ----- Prompt Powerlevel10k (~/.p10k.zsh) ----------------------------------
uninstall_prompt_pk10() {
  msg_title "Uninstall Prompt Powerlevel10k"

  remove_p10k_configs

  msg_installed "Prompt Powerlevel10k uninstalled"
}

check_install_prompt_pk10() {
  if file_exists "$HOME/.p10k.zsh"; then
    msg_found "Installed"
  else
    msg_not_found "Not installed"
  fi
}

# ----- Uninstall-menu status checks ----------------------------------------
# These reflect whether OUR specific artifacts are in place (comparing against
# the bundled resources / files the uninstaller actually removes), so the menu
# visibly flips to "Not installed" right after uninstalling.

# The installer's own check is the authoritative one here: an exact file compare
# would report "Not installed" as soon as the user appends a single line to their
# ~/.zshrc, which is normal and expected.
status_zshrc() {
  check_override_zshrc_file
}

# ----- Theme Agnoster ------------------------------------------------------
uninstall_theme_agnoster() {
  msg_title "Uninstall Theme Agnoster"
  local theme_file="$HOME/.oh-my-zsh/custom/themes/$agnoster_file_name"

  if has_backup agnoster_theme; then
    restore_path "$theme_file" agnoster_theme
  else
    rm -f "$theme_file"
  fi

  msg_installed "Theme Agnoster uninstalled"
}

# ----- zshrc ---------------------------------------------------------------
uninstall_zshrc() {
  msg_title "Uninstall zshrc"

  local initial_backup
  initial_backup="$(zshrc_initial_backup_path)"

  if [ -n "$initial_backup" ]; then
    cp "$initial_backup" "$HOME/.zshrc"
    msg_found "Restored ~/.zshrc from $initial_backup"
  elif has_backup zshrc; then
    restore_path "$HOME/.zshrc" zshrc
  else
    rm -f "$HOME/.zshrc"
  fi

  # Remove every zshrc backup the wizard ever made (initial + timestamped).
  rm -f "$HOME/.zshrc".initial-mac-backup-* "$HOME/.zshrc".backup-*

  msg_installed "zshrc uninstalled"
}

# ----- Mac Cursor speed ----------------------------------------------------
uninstall_keyrepeat() {
  msg_title "Uninstall Mac Cursor speed"
  restore_defaults -g KeyRepeat keyrepeat_key
  restore_defaults -g InitialKeyRepeat keyrepeat_delay
  rm -f "$keyrepeat_custom_state"
  msg_installed "Mac Cursor speed reset (logout/login to take effect)"
}

# ----- Mac Trackpad secondary click ----------------------------------------
uninstall_trackpad_secondary_click() {
  msg_title "Uninstall Mac Trackpad secondary click"
  _trackpad_secondary_click_apply off
  msg_installed "Trackpad secondary click disabled"
}

# ----- Mac Finder hidden files ---------------------------------------------
uninstall_finder_hidden() {
  msg_title "Uninstall Mac Finder hidden files"
  restore_defaults com.apple.finder AppleShowAllFiles finder_show_all_files
  killall Finder 2>/dev/null
  msg_installed "Finder hidden-files setting reset to its pre-install state"
}

# ----- GitHub CLI ----------------------------------------------------------
uninstall_github_cli() {
  msg_title "Uninstall GitHub CLI"
  if command_exists brew && brew list gh >/dev/null 2>&1; then
    brew uninstall gh
    msg_installed "GitHub CLI uninstalled"
  elif command_exists gh; then
    msg_warning "gh is installed but not via Homebrew; skipping automatic removal"
  else
    msg_found "GitHub CLI is not installed"
  fi
}

# ----- Gitmoji -------------------------------------------------------------
uninstall_gitmoji() {
  msg_title "Uninstall Gitmoji"
  if command_exists npm && npm ls -g gitmoji-cli >/dev/null 2>&1; then
    npm uninstall -g gitmoji-cli
    msg_installed "Gitmoji CLI uninstalled"
  elif command_exists gitmoji; then
    msg_warning "gitmoji CLI is installed but not via npm global; skipping automatic removal"
  else
    msg_found "Gitmoji CLI is not installed"
  fi
}

# ----- Gitmoji commit-hook -------------------------------------------------
# Removes the gitmoji commit-msg hook from the current repository only.
uninstall_gitmoji_hook() {
  msg_title "Uninstall Gitmoji commit-hook"

  if ! git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
    msg_warning "The current directory is not a git repository. Run this inside a project to remove the commit-hook."
    return
  fi

  local hook
  hook="$(git rev-parse --git-path hooks/prepare-commit-msg 2>/dev/null)"
  if [ -f "$hook" ] && grep -q "gitmoji" "$hook" 2>/dev/null; then
    rm -f "$hook"
    msg_installed "Gitmoji commit-hook removed from this repository"
  else
    msg_found "No Gitmoji commit-hook found in this repository"
  fi
}

# ----- tree ----------------------------------------------------------------
uninstall_tree_command() {
  msg_title "Uninstall tree"
  if command_exists brew && brew list tree >/dev/null 2>&1; then
    brew uninstall tree
    msg_installed "tree uninstalled"
  elif command_exists tree; then
    msg_warning "tree is installed but not via Homebrew; skipping automatic removal"
  else
    msg_found "tree is not installed"
  fi
}
