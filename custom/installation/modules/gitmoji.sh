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

  # Point Node at the corporate root CA so gitmoji can reach its API through an
  # SSL-inspecting proxy. Only export it when the file actually exists, otherwise
  # Node prints a confusing "load failed / No such file" warning.
  if [ -f "$HOME/certs/company-root.crt" ]; then
    export NODE_EXTRA_CA_CERTS="$HOME/certs/company-root.crt"
  fi

  # `gitmoji -i` installs the commit-msg hook, which only works inside a git
  # repository. During "Install all" the working directory isn't a repo, so guard
  # it to avoid the "not a git repository" error aborting the step. Still sync the
  # emoji cache so the picker isn't empty when the hook is set up later.
  if git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
    gitmoji -i
  else
    gitmoji -u >/dev/null 2>&1
    msg_warning "Skipped commit-hook init (not in a git repo). Run 'gitmoji -i' inside a project to enable it."
  fi

  msg_installed "Gitmoji installed"
}

check_install_gitmoji() {
  if command_exists gitmoji; then
    msg_found_version "Installed" "$(extract_version "$(gitmoji --version 2>/dev/null | head -1)")"
  else
    msg_not_found "Not installed"
  fi
}
