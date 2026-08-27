#!/usr/bin/env bash

install_gitmoji() {
  new_line
  msg_title "Gitmoji"

  if ! command_exists brew; then
    msg_warning "Homebrew is not installed. Please install Homebrew first."
    return
  fi

  msg_searching "Installing Gitmoji"
  brew install gitmoji
  gitmoji -i
  msg_installed "Gitmoji installed"
}

check_install_gitmoji() {
  if command_exists gitmoji; then
    msg_found_version "Installed" "$(extract_version "$(gitmoji --version 2>/dev/null | head -1)")"
  else
    msg_not_found "Not installed"
  fi
}
