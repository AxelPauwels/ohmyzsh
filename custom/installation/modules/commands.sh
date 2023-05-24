#!/usr/bin/env bash

check_install_tree_command() {
  if command_exists tree; then
    msg_found "Installed"
  else
    msg_not_found "Not installed"
  fi
}

install_tree_command() {
  install_brew
  msg_searching "Searching for tree command"

  if command_exists tree; then
    msg_found "Found"
  else
    msg_not_found "Not found"

    msg_searching "Installing tree command"
    brew install tree
    msg_searching "Installed"
  fi

  msg_installed "Tree command installed"
}
