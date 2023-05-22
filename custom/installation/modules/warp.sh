#!/usr/bin/env bash

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

# manual-installation-check
check_install_warp() {
  if app_exists Warp; then
    msg_found "Installed"
  else
    msg_not_found "Not installed"
  fi
}

# manual-installation
install_warp_manually() {
  install_warp
}
