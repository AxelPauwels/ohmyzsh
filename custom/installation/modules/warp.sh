#!/usr/bin/env bash

warp_theme_name="Custom"
warp_theme_destination="$HOME/.warp/themes/$warp_theme_name.yaml"

install_warp() {
  new_line
  msg_title "Warp"
  msg_searching "Checking warp installation"

  if
    app_exists Warp
  then
    msg_found "Found"
  else
    msg_not_found "Not installed"

    msg_searching "Installing Warp"
    install_brew
    brew install --cask warp
  fi

  msg_installed "Warp installed"
}

check_install_warp() {
  if app_exists Warp; then
    msg_found "Installed"
  else
    msg_not_found "Not installed"
  fi
}

install_warp_manually() {
  install_warp
}

install_warp_theme() {
  msg_title "Warp theme"
  msg_searching "Searching for themes directory"

  if ! dir_exists "$HOME/.warp"; then
    mkdir "$HOME/.warp"
  fi

  if ! dir_exists "$HOME/.warp/themes"; then
    mkdir "$HOME/.warp/themes"
  fi

  if dir_exists "$HOME/.warp/themes"; then
    msg_found "Found"

    msg_searching "Searching for custom theme"

    if ! file_exists "$warp_theme_destination"; then
      msg_not_found "Not found"

      msg_searching "Installing custom theme"
      source "$ZSH_INSTALL"/resources/warp/themes/installable-custom-warp-theme.sh
      msg_found "Installed"
    else
      msg_found "custom theme already installed"
    fi
    msg_installed "Custom warp theme installed"
  fi
}

check_install_warp_theme() {
  if file_exists "$warp_theme_destination"; then
    msg_found "Installed"
  else
    msg_not_found "Not installed"
  fi
}

install_warp_theme_manually() {
  install_warp_theme
}
