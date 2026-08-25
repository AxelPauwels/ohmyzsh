#!/usr/bin/env bash

install_node() {
  if command_exists brew; then
    brew install node
  else
    msg_warning "Homebrew is not installed. Please install Homebrew first."
  fi
}

check_install_node() {
  if command_exists node; then
    msg_found "Installed"
  else
    msg_not_found "Not installed"
  fi
}
