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
    msg_found "Installed"
  else
    msg_not_found "Not installed"
  fi
}
