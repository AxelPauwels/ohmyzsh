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

# ----- iTerm color & font settings -----------------------------------------
uninstall_color_preset_and_font() {
  msg_title "Uninstall iTerm color & font settings"

  if has_backup iterm2_plist; then
    restore_path "$iterm2_plist" iterm2_plist
    msg_found "Restored original iTerm2 preferences"
  elif [ -f "$iterm2_plist.old" ]; then
    mv "$iterm2_plist.old" "$iterm2_plist"
    msg_found "Restored iTerm2 preferences from .old backup"
  else
    msg_warning "No plist backup found; removing our custom defaults only"
  fi

  # Always drop our custom defaults keys so the status flips immediately even
  # if cfprefsd still has the plist cached.
  defaults delete com.googlecode.iterm2 "$defaults_is_our_custom_color_and_font" 2>/dev/null
  defaults delete com.googlecode.iterm2 "$defaults_color_preset_key" 2>/dev/null

  # Remove the imported color scheme directory we created.
  restore_path "$ZSH_CUSTOM/schemes" iterm_schemes

  rm -f "$iterm2_plist.old"
  killall cfprefsd 2>/dev/null

  msg_installed "iTerm color & font settings uninstalled (restart iTerm2)"
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

  msg_installed "Theme Powerlevel10k uninstalled"
}

# ----- Prompt Powerlevel10k (~/.p10k.zsh) ----------------------------------
uninstall_prompt_pk10() {
  msg_title "Uninstall Prompt Powerlevel10k"

  if has_backup p10k_config; then
    restore_path "$HOME/.p10k.zsh" p10k_config
  elif [ -f "$HOME/.p10k.zsh.old" ]; then
    mv "$HOME/.p10k.zsh.old" "$HOME/.p10k.zsh"
  else
    rm -f "$HOME/.p10k.zsh"
  fi

  rm -f "$HOME/.p10k.zsh.old"
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

status_zshrc() {
  if [ -f "$HOME/.zshrc" ] && cmp -s "$HOME/.zshrc" "$ZSH_INSTALL/resources/.zshrc"; then
    msg_found "Installed"
  else
    msg_not_found "Not installed"
  fi
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

  if has_backup zshrc; then
    restore_path "$HOME/.zshrc" zshrc
  elif [ -f "$HOME/.zshrc.old" ]; then
    mv "$HOME/.zshrc.old" "$HOME/.zshrc"
  else
    rm -f "$HOME/.zshrc"
  fi

  rm -f "$HOME/.zshrc.old"
  msg_installed "zshrc uninstalled"
}

# ----- Mac Cursor speed ----------------------------------------------------
uninstall_keyrepeat() {
  msg_title "Uninstall Mac Cursor speed"
  restore_defaults -g KeyRepeat keyrepeat_key
  restore_defaults -g InitialKeyRepeat keyrepeat_delay
  msg_installed "Mac Cursor speed reset (logout/login to take effect)"
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
