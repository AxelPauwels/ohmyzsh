#!/usr/bin/env bash

install_gitmoji() {
  new_line
  msg_title "Gitmoji"

  if ! command_exists npm; then
    msg_warning "npm is not installed. Please install Node/npm first."
    return
  fi

  msg_searching "Installing Gitmoji CLI"
  npm i -g gitmoji-cli

  msg_installed "Gitmoji CLI installed"
}

check_install_gitmoji() {
  if command_exists gitmoji; then
    msg_found_version "Installed" "$(extract_version "$(gitmoji --version 2>/dev/null | head -1)")"
  else
    msg_not_found "Not installed"
  fi
}

# Installs the gitmoji commit-msg hook into the current repository. The hook only
# works inside a git repository, so guard against running it elsewhere.
install_gitmoji_hook() {
  new_line
  msg_title "Gitmoji CLI commit-hook"

  if ! command_exists gitmoji; then
    msg_warning "Gitmoji CLI is not installed. Please install Gitmoji CLI first."
    return
  fi

  if ! git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
    msg_warning "The current directory is not a git repository. Run this inside a project to enable the commit-hook."
    return
  fi

  msg_searching "Installing Gitmoji commit-hook in this repository"
  gitmoji -i
  msg_installed "Gitmoji commit-hook installed in this repository"
}

check_install_gitmoji_hook() {
  local hook
  if git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
    hook="$(git rev-parse --git-path hooks/prepare-commit-msg 2>/dev/null)"
    if [ -f "$hook" ] && grep -q "gitmoji" "$hook" 2>/dev/null; then
      msg_found "Installed in this repo"
    else
      msg_not_found "Not installed in this repo"
    fi
  else
    msg_not_found "Not a git repository"
  fi
}
