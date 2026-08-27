#!/usr/bin/env bash

install_gitmoji() {
  new_line
  msg_title "Gitmoji"

  if ! command_exists npm; then
    msg_warning "npm is not installed. Please install Node/npm first."
    return
  fi

  msg_searching "Installing Gitmoji"
  npm i -g gitmoji-cli
  export NODE_EXTRA_CA_CERTS="$HOME/certs/company-root.crt"
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
