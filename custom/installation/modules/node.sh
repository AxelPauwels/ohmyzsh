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
    local node_version npm_version details
    node_version="$(node --version 2>/dev/null)"
    npm_version="$(npm --version 2>/dev/null)"
    details="node ${node_version}"
    if [ -n "$npm_version" ]; then
      details="${details}, npm v${npm_version}"
    fi
    msg_found_version "Installed" "$details"
  else
    msg_not_found "Not installed"
  fi
}
