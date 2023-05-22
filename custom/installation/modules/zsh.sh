#!/usr/bin/env bash

zsh_documentation="https://github.com/ohmyzsh/ohmyzsh/wiki/Installing-ZSH"

## will check if zsh is installed (should come with mac OS now)
install_zsh() {
  new_line
  msg_title "Zsh"
  msg_searching "Checking Zsh installation"

  if command_exists zsh; then
    msg_found "Found"
    msg_installed "Zsh installed"
  else
    msg_error "Zsh is not installed yet"
    echo "*TODO -> do you want to install this?"
  fi
}

# manual-installation-check
check_install_zsh() {
  if command_exists zsh; then
    msg_found "Installed"
  else
    msg_not_found "Not installed"
  fi
}

# manual-installation
install_zsh_manually() {
  msg_italic "Currently not developed yet. You can install it here:"
  msg_inline "URL: "
  msg_url "$zsh_documentation"
}
