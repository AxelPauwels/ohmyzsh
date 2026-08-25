#!/usr/bin/env bash

install_nvm() {
  if command_exists brew; then
    brew install nvm
  else
    msg_warning "Homebrew is not installed. Please install Homebrew first."
  fi
}

check_install_nvm() {
  if brew list nvm &>/dev/null; then
    msg_found_version "Installed" "$(brew list --versions nvm 2>/dev/null | head -1)"
  else
    msg_not_found "Not installed"
  fi
}
