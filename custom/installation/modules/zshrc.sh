#!/usr/bin/env bash

zshrc_path="$HOME/.zshrc"

# Prints the path of the pristine "initial mac" backup, if one exists.
zshrc_initial_backup_path() {
  ls -1t "$zshrc_path".initial-mac-backup-* 2>/dev/null | head -1
}

override_zshrc_file() {
  new_line
  msg_title "Create/Override zshrc"
  msg_searching "Searching zshrc file"

  if file_exists "$zshrc_path"; then
    msg_found "Found"

    # The very first install keeps a pristine snapshot of the user's original
    # Mac zshrc named ".zshrc.initial-mac-backup-<datetime>" so the uninstaller
    # can restore it. Every later install only adds a ".zshrc.backup-<datetime>"
    # so no version is ever lost.
    if [ -z "$(zshrc_initial_backup_path)" ]; then
      msg_searching "Creating initial backup of your original zshrc file"
      zshrc_backup="${zshrc_path}.initial-mac-backup-$(date +%Y-%m-%d_%H-%M-%S)"
      cp "$zshrc_path" "$zshrc_backup"
      msg_found "Backed up to $zshrc_backup"
    else
      msg_searching "Copying existing zshrc file as a timestamped backup"
      zshrc_backup=$(backup_file_datetime "$zshrc_path")
      msg_found "Backed up to $zshrc_backup"
    fi

    msg_searching "Overriding existing zshrc file"
    cp "$ZSH_INSTALL/resources/.zshrc" "$HOME/"
    msg_found "Overridden"
  else
    msg_warning "No zshrc file found"

    msg_searching "Creating a new zshrc file"
    cp "$ZSH_INSTALL/resources/.zshrc" "$HOME/"
    msg_found "zshrc file created"
  fi

  msg_installed "zshrc done"
}

check_override_zshrc_file() {
  zshrcIsUpToDate=true
  zshrcIsUpToDateMessage="Seems up-to-date (Just checked your themes)"
  p10k_theme_is_installed_but_not_in_zshrc=false
  agnoster_theme_is_installed_but_not_in_zshrc=false
  p10kErrorMessage="You have Powerlevel10k theme, but not configured in Zshrc file"
  agnosterErrorMessage="You have Agnoster theme, but not configured in Zshrc file"

  if ! file_exists "$zshrc_path"; then
    msg_not_found "No file found (forgotten to install zsh?)"
    return
  fi

  p10k_theme="powerlevel10k/powerlevel10k"
  p10k_theme_path="$HOME/.oh-my-zsh/custom/themes/powerlevel10k"
  agnoster_theme="agnoster"
  agnoster_theme_path="$HOME/.oh-my-zsh/custom/themes/agnoster"

  # if theme is installed, but not in zshrc
  if dir_exists "$p10k_theme_path"; then
    p10k_theme_is_installed=true
    if ! file_contains_string "$zshrc_path" "$p10k_theme"; then
      p10k_theme_is_installed_but_not_in_zshrc=true
    fi
  fi

  # if theme is installed, but not in zshrc
  if dir_exists "$agnoster_theme_path"; then
    if ! file_contains_string "$zshrc_path" "$agnoster_theme"; then
      agnoster_theme_is_installed_but_not_in_zshrc=true
    fi
  fi

  # show message
  if ! $p10k_theme_is_installed_but_not_in_zshrc && ! $agnoster_theme_is_installed_but_not_in_zshrc; then
    msg_found "$zshrcIsUpToDateMessage"
  else
    if $p10k_theme_is_installed_but_not_in_zshrc; then
      msg_not_found "$p10kErrorMessage"
    else
      msg_not_found "$agnosterErrorMessage"
    fi
  fi
}

override_zshrc_file_manually() {
  override_zshrc_file
}
